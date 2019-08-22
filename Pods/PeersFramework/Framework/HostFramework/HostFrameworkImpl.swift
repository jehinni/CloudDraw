import Foundation
import os.log

public class HostFrameworkImpl: NSObject, HostFramework {
    
    public weak var appDelegate: HostAppDelegate? // interact with app to display stuff
    var currentGameDelegate: HostGame? // delegate for currently played game
    var connectivity: Connectivity // handle connections and message sending & receiving
    let hostPeer: Peer // the peer instace of the host
    var messageHandler: HostMessageHandler? // handles incomming messages from players
    var sendHandler: HostSendHandler? // handles sending messages to players
    var playersHandler: PlayersHandler? // handles player modes (connected, standby, playing)
    
    // Is set if a player requests a game session.
    // Is reset when not enough players want to participate in a game or if a game finished.
    var gameStartAt: Date?
    var gameStartTimer: Timer?
    
    // Is set if a GameInitialize message was sent to the players.
    // If not all players responded within a given time, those players will be removed
    // from the playingPlayers and the game will be started anyways.
    var gameInitializeTimer: Timer?
    
    required public init(peer: Peer) {
        self.hostPeer = peer
        self.connectivity = ConnectivityFactory.makeConnectivity(peer: self.hostPeer)
        super.init()
        self.connectivity.delegate = self
        // Initialize handlers
        self.messageHandler = HostMessageHandler()
        self.messageHandler?.hostFramework = self
        self.playersHandler = PlayersHandler()
        self.playersHandler?.hostFramework = self
        self.sendHandler = HostSendHandler()
        self.sendHandler?.hostFramework = self
        // Make host visible for players so they can join the game session
        self.connectivity.startAdvertising()
    }
    
    // Notify all players (except the initializing one) that a game
    // can start soon, so they can decide whether to participate.
    // After a coundown, if enough players want to participate,
    // a random game is chosen, initialized by the host and
    // passed to all participating players to initialize it as well.
    func handleGameSessionRequest(request: GameSessionRequest, from peer: Peer) throws {
        
        guard self.gameStartAt == nil else {
            os_log("[FRAMEWORK] multiple game session requests, ignoring this one - game already starts at %s", self.gameStartAt!.description)
            return
        }
        
        guard let playersHandler = self.playersHandler else {
            os_log("[FRAMEWORK] playersHandler is undefined in handleGameSessionRequest()", type: .error)
            throw FrameworkError.weakVarUndefined
        }
        guard playersHandler.players.count >= 2 else { throw FrameworkError.notEnoughPlayers }
        
        let startAt = Date().add(.second, value: 15)
        self.gameStartAt = startAt
        self.appDelegate?.showGameCouldStartSoon(startAt: startAt)
        self.sendHandler?.sendToSomePlayers(message: GameCouldStartSoon(startAt: startAt), to: playersHandler.players.filter({ $0.peer != peer }))
        self.sendHandler?.sendToSomePlayers(message: AcceptGameRequest(startAt: startAt), to: playersHandler.players.filter({ $0.peer == peer }))
        playersHandler.playingPlayers = []
        playersHandler.initializedPlayingPlayers = []
        if let initializingPlayer = playersHandler.players.first(where: { $0.peer == peer }) {
            playersHandler.playingPlayers.append(initializingPlayer)
            self.appDelegate?.showPlayerJoinedGame(initializingPlayer)
        }
        let gameInfo = try GameCompatibilityChecker(for: playersHandler.playingPlayers).randomGame()
        let timer = Timer(fire: startAt, interval: 0, repeats: false, block: { timer in
            guard playersHandler.playingPlayers.count >= 2 else {
                os_log("[FRAMEWORK] Cannot start gameplay, less than 2 players want to participate.")
                self.sendHandler?.sendToAllPlayers(message: GameCannotStartTooFewPlayers())
                self.appDelegate?.showGameCannotStartTooFewPlayers()
                self.gameStartAt = nil
                return
            }
            guard let gameFactory = self.appDelegate?.gameFactory else {
                os_log("[FRAMEWORK] Game Factory of App Delegate unexpectedly undefined.", type: .error)
                return
            }
            do {
                self.currentGameDelegate = try gameFactory.createHostGame(with: gameInfo)
                self.currentGameDelegate!.framework = self
            } catch {
                os_log("[FRAMEWORK] Error while instatiating a game: %@", type: .error, error.localizedDescription)
            }
            self.sendHandler?.sendToPlayingPlayers(message: GameInitialize(gameInfo: gameInfo))
            self.gameInitializeTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
                self.gameInitializeTimer = nil
                guard let initializedPlayingPlayers = self.playersHandler?.initializedPlayingPlayers, let playingPlayers = self.playersHandler?.playingPlayers else {
                    os_log("[FRAMEWORK] Failed to get initializedPlayingPlayers and playingPlayers", type: .error)
                    return
                }
                guard initializedPlayingPlayers.count < playingPlayers.count else {
                    return
                }
                self.playersHandler?.playingPlayers = playingPlayers.filter({ initializedPlayingPlayers.contains($0) })
                do {
                    try self.startGameLifecycle()
                } catch {
                    os_log("[FRAMEWORK] Failed to start game lifecycle after deleting not-responding playing players: %@", type: .error, error.localizedDescription)
                }
            })
        })
        RunLoop.main.add(timer, forMode: .common)
        self.gameStartTimer = timer
    }
    
    // Add players that want to participate in the next game to the according list and inform the app.
    // Inform the player that join next game was successful 
    func handleJoinNextGame(request: JoinNextGame, from peer: Peer) throws {
        guard let player = self.playersHandler?.players.first(where: { $0.peer == peer }) else {
            throw FrameworkError.couldNotFindPlayerByPeer
        }
        
        guard let playersHandler = self.playersHandler else {
            os_log("[FRAMEWORK] playersHandler is undefined in handleJoinNextGame()", type: .error)
            throw FrameworkError.weakVarUndefined
        }
        
        self.playersHandler?.playingPlayers.append(player)
        self.appDelegate?.showPlayerJoinedGame(player)
        
        self.sendHandler?.sendToSomePlayers(message: JoinNextGameSuccessful(), to: playersHandler.players.filter({ $0.peer == peer }))
    }
    
    // Add playing players that have initialized the next game to the according list to
    // wait with preparation until all participating players have initialized the game.
    func handleGameInitialized(request: GameInitialized, from peer: Peer) throws {
        guard let player = self.playersHandler?.players.first(where: { $0.peer == peer }) else {
            throw FrameworkError.couldNotFindPlayerByPeer
        }
        self.playersHandler?.initializedPlayingPlayers.append(player)
        guard self.playersHandler?.initializedPlayingPlayers.count == self.playersHandler?.playingPlayers.count else {
            return
        }
        if self.gameInitializeTimer != nil {
            self.gameInitializeTimer?.invalidate()
            self.gameInitializeTimer = nil
        }
        try self.startGameLifecycle()
    }
    
    // Start game lifecycle consisting of preparation, gameplay and evaluation.
    func startGameLifecycle() throws {
        guard let gameDelegate = self.currentGameDelegate else {
            os_log("[FRAMEWORK] gameDelegate is undefined in startGameLifecycle()", type: .error)
            throw FrameworkError.weakVarUndefined
        }
        guard let playingPlayers = self.playersHandler?.playingPlayers else { throw FrameworkError.playingPlayersUndefined }
        gameDelegate.prepare(players: playingPlayers)
        self.sendHandler?.sendToPlayingPlayers(message: GameStarts())
        gameDelegate.play()
    }
    
    // Send a game message to all or some playing players. Should only be used by games.
    public func sendGameDataToPlayers<T>(message: T, to players: [Player]?, sendMode: SessionSendDataMode?) where T: Codable {
        self.sendHandler?.sendGameDataToPlayers(message: message, to: players, sendMode: sendMode ?? .reliable)
    }
    
    // End the gameplay. Should only be used by games.
    public func finishGame() {
        do {
            guard let gameDelegate = self.currentGameDelegate else {
                os_log("[FRAMEWORK] gameDelegate is undefined in finishGame()", type: .error)
                throw FrameworkError.weakVarUndefined
            }
            guard let playingPlayers = self.playersHandler?.playingPlayers else { throw FrameworkError.playingPlayersUndefined }
            let gamePlayers: [GamePlayer] = gameDelegate.evaluate()
            try RankingGenerator(for: gamePlayers).generateRanking()
            self.appDelegate?.showRanking(for: playingPlayers) // FIXME FRAMEWORK maybe: reference equality of rankedPlayers and playingPlayers?
            self.sendHandler?.sendToPlayingPlayers(message: GameResult(players: playingPlayers))
            self.gameStartAt = nil
            self.appDelegate?.resetPlayingPlayers()
            self.currentGameDelegate = nil
        } catch {
            os_log("[FRAMEWORK] Could not finish game: %@", type: .error, error.localizedDescription)
        }
    }
    
    // Disconnect the host from any connections.
    public func disconnect() {
        self.connectivity.disconnect()
        self.gameInitializeTimer?.invalidate()
        self.gameStartTimer?.invalidate()
        self.currentGameDelegate?.terminate {
            self.currentGameDelegate = nil
        }
    }
    
    deinit {
        self.connectivity.stopAdvertising()
    }
}

extension HostFrameworkImpl: ConnectivityDelegate {
    
    // Let the playerHandler handle connecting and disconnecting players.
    func session(_ peer: Peer, didChange state: SessionState) {
        switch state {
        case .connected: self.playersHandler?.playerConnected(peer)
        case .notConnected: self.playersHandler?.playerDisconnected(peer)
        default: return
        }
    }
    
    // Let the messageHandler handle messages received from players.
    func session(didReceive data: Data, fromPeer peer: Peer) {
        do {
            let message: MessageWrapper = try MessageWrapper.decode(data)
            self.messageHandler?.handle(message: message, from: peer)
        } catch {
            os_log("[FRAMEWORK] Failed to decode message from peer: %@", type: .error, error.localizedDescription)
        }
    }
    
    func session(didReceive stream: InputStream, withName streamName: String, fromPeer peer: Peer) {
        os_log("[FRAMEWORK] Handling of received InputStream not implemented yet!", type: .error)
    }
    
    func session(didStartReceivingResourceWithName resourceName: String, fromPeer peer: Peer, with progress: Progress) {
        os_log("[FRAMEWORK] Handling of start receiving resource not implemented yet!", type: .error)
    }
    
    func session(didFinishReceivingResourceWithName resourceName: String, fromPeer peer: Peer, at localURL: URL?, withError error: Error?) {
        os_log("[FRAMEWORK] Handling of finish receiving resource not implemented yet!", type: .error)
    }
    
    // Let the playersHandler handle connection requests from players.
    func answerInvitation(didReceiveInvitationFromPeer peer: Peer) throws -> Bool {
        guard let playersHandler = self.playersHandler else {
            os_log("[FRAMEWORK] playersHandler is undefined in answerInvitation()", type: .error)
            throw FrameworkError.weakVarUndefined
        }
        return playersHandler.connectPlayer(peer)
    }
}
