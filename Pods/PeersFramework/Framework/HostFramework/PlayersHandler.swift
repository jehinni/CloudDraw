import Foundation
import os.log

class PlayersHandler: NSObject { 
    
    weak var hostFramework: HostFrameworkImpl?
    
    var players: [Player] // actively connected players
    var playingPlayers: [Player] // players participating in current game
    var initializedPlayingPlayers: [Player] // playing players that have initialized the game
    var standbyPlayers: [(Player, Date)] // previously connected players (disconnected at date)
    
    // Maximum number of players technically supported by Connectivity.
    var maxNumberOfPlayers : Int {
        guard let connectivity = self.hostFramework?.connectivity else {
            os_log("[FRAMEWORK] Connectivity instance of host framework is unexpectedly undefined.", type: .error)
            return 0
        }
        return connectivity.maxNumberOfPeers - 1
    }
    
    override init() {
        self.players = []
        self.playingPlayers = []
        self.initializedPlayingPlayers = []
        self.standbyPlayers = []
        super.init()
        self.clearStandbyPlayersRegularly()
    }
    
    // Always accept invitations from players that want to join our game session,
    // except if the maximum number of players is already reached.
    func connectPlayer(_ peer: Peer) -> Bool {
        return players.count < maxNumberOfPlayers
    }
    
    // Associate connecting peers with standby players or create new players for the peers.
    // Stop advertising if the maximum number of peers is reached.
    // Let the app know if a new player connected or new connections are no longer possible.
    // Let all active players know if enough players connected, so that a game is possible.
    // If a game invitation was sent before the new player connected, send them the invitation
    // as well to give them the chance to participate.
    func playerConnected(_ peer: Peer) {
        let player = addPlayer(for: peer)
        guard let hostFramework = self.hostFramework else {
            os_log("[FRAMEWORK] hostFramework is nil in playerConnected()", type: .error)
            return
        }
        if (players.count >= maxNumberOfPlayers) {
            hostFramework.connectivity.stopAdvertising()
            hostFramework.appDelegate?.showConnectionsNotPossible()
        }
        hostFramework.appDelegate?.showNewPlayerConnected(player)
        guard players.count >= 2 else { return }
        if let startAt = hostFramework.gameStartAt, startAt > Date() {
            hostFramework.sendHandler?.sendToSomePlayers(message: GameCouldStartSoon(startAt: startAt), to: [player])
        } else {
            hostFramework.sendHandler?.sendToAllPlayers(message: GamePossible())
        }
    }
    
    // Put the disconnecting peers' players in standby mode.
    // Start advertising again, if the number of peers falls under the maximum.
    // Let the app know when a player changed to standby mode and
    // if new connections are possible again.
    // Let all active players know if a game is no longer possible.
    func playerDisconnected(_ peer: Peer) {
        if let player = players.first(where: { $0.peer == peer }) {
            self.hostFramework?.currentGameDelegate?.lostPlayer(player)
        }
        let playerCount = players.count
        let player: Player? = putPlayerInStandby(for: peer)
        if didPlayerCountFallUnderMaximum(previous: playerCount) {
            self.hostFramework?.connectivity.startAdvertising()
            self.hostFramework?.appDelegate?.showConnectionsPossible()
        }
        if players.count < 2 {
            self.hostFramework?.sendHandler?.sendToAllPlayers(message: GameNotPossible())
        }
        if player != nil {
            self.hostFramework?.appDelegate?.showPlayerChangedToStandby(player!)
        }
    }
    
    // If the peer was previously connected and we have a standby player for them, move that player
    // out of the standbyPlayers and into the active players. If not, create a new player object that
    // we associate with the peer.
    func addPlayer(for peer: Peer) -> Player {
        let standbyPlayer: (Player, Date)? = self.standbyPlayers.first(where: { $0.0.peer == peer })
        let player: Player = standbyPlayer?.0 ?? Player(peer: peer)
        if (standbyPlayer != nil) {
            self.standbyPlayers.remove(at: self.standbyPlayers.firstIndex(where: { $0.0 == standbyPlayer?.0 })!)
        }
        self.players.append(player)
        // TODO FRAMEWORK: already match game versions here?
        return player
    }
    
    // If the peer is associated with a player, move them from the active players
    // into the standby players.
    func putPlayerInStandby(for peer: Peer) -> Player? {
        guard let player: Player = self.players.first(where: { $0.peer == peer }) else {
            return nil
        }
        if let index = self.playingPlayers.firstIndex(of: player) {
            self.playingPlayers.remove(at: index)
        }
        self.players.remove(at: self.players.firstIndex(of: player)!)
        self.standbyPlayers.append((player, Date()))
        return player
    }
    
    // True if the previous player count is higher than the current one AND
    // the current player count is lower than the maximum one.
    func didPlayerCountFallUnderMaximum(previous playerCount: Int) -> Bool {
        return playerCount > self.players.count && self.players.count < self.maxNumberOfPlayers && playerCount >= self.maxNumberOfPlayers
    }
    
    // Remove standby players disconnected for at least 30 min regularly
    // (every minute) to not let the list get infinite.
    // (If the player wants to join the game afterwards, the device has to
    // reconnect like a new one and the player starts at 0 points again.)
    func clearStandbyPlayersRegularly() {
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { timer in
            self.standbyPlayers.filter({ Int(Date().timeIntervalSince($0.1)) % 60 >= 1800 })
                .forEach({ self.hostFramework?.appDelegate?.showStandbyPlayerDeleted($0.0)
            })
            self.standbyPlayers.removeAll(where: { Int(Date().timeIntervalSince($0.1)) % 60 >= 1800 })
        })
    }
}
