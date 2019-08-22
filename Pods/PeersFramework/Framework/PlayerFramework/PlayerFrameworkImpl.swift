import Foundation
import os.log

public class PlayerFrameworkImpl: NSObject, PlayerFramework {
    
    public weak var appDelegate: PlayerAppDelegate? // interact with app to display stuff
    var currentGameDelegate: PlayerGame? // delegate for currently played game
    var connectivity: Connectivity // handle connections and message sending & receiving
    var playerPeer: Peer // the peer instace of the peer
    var messageHandler: PlayerMessageHandler? // handles incomming messages from the host
    var sendHandler: PlayerSendHandler? // handles sending messages to the host
    var connectedHost: Peer? // the host we are connected with
    
    required public init(peer: Peer) {
        self.playerPeer = peer
        self.connectivity = ConnectivityFactory.makeConnectivity(peer: peer)
        super.init()
        self.connectivity.delegate = self
        // Initialize handlers
        self.messageHandler = PlayerMessageHandler()
        self.messageHandler?.playerFramework = self
        self.sendHandler = PlayerSendHandler()
        self.sendHandler?.playerFramework = self
    }
	
	// Peer has chosen to be player.
	// Player will start browsing for available hosts.
	public func startBrowsing() {
		connectivity.startBrowsing()
	}
	
	// Player has connected to a host.
	// Now the player should stop browsing for hosts.
	public func stopBrowsing() {
		connectivity.stopBrowsing()
	}
    
    // Invite the chosen host to connect (he will always accept
    // unless maximum number of players is reached).
    public func connectToHost(peer: Peer) throws {
        try connectivity.invitePeer(peer)
    }
    
    // Disconnect the player from any connections.
    public func disconnect() {
        connectivity.disconnect()
    }
    
    // At least two peers are connected, thus can start a game session.
    // Tell the app to display this (show a "let's play" button).
    func handleGamePossible() {
        self.appDelegate?.showGamePossible()
    }
    
    // Less than two players are connected, so a game is no longer possible.
    // Tell the app to display this (no "let's play" button).
    func handleGameNotPossible() {
        self.appDelegate?.showGameNotPossible()
    }
    
    // Tell the host that this player wants to start a game.
    public func requestGame(peer: Peer) {
        self.sendHandler?.sendToHost(message: GameSessionRequest(peer: peer))
    }
    
    // A game is about to start, so the player can chose whether to participate.
    // Tell the app to display this ("join game" button).
    func handleGameCouldStartSoon(request: GameCouldStartSoon) {
        self.appDelegate?.showGameCouldStartSoon(at: request.startAt)
    }
    
    // Tell the app that the start game request was successful
    func handleAcceptGameRequest(request: AcceptGameRequest) {
        self.appDelegate?.showAcceptGameRequest(at: request.startAt)
    }
	
    // A game session has been requested, but not enough players joined.
    func handleGameCannotStartTooFewPlayers() {
        self.appDelegate?.showGameCannotStartTooFewPlayers()
    }
    
    // Tell the host that the player wants to participate in the next game.
    public func joinNextGame() {
        self.sendHandler?.sendToHost(message: JoinNextGame())
    }
    
    // Tell the app that join game was successful
    public func handleJoinedNextGameSuccessfully() {
        self.appDelegate?.joinedNextGameSuccessfully()
    }
    
    // Tell the current game to terminate
    public func terminateGame(completionHandler: @escaping () -> Void) {
        guard let game = self.currentGameDelegate else {
            os_log("[FRAMEWORK] No game running, won't terminate anything")
            completionHandler()
            return
        }
        os_log("[FRAMEWORK] Terminating current game")
        game.terminate(completionHandler: completionHandler)
    }
    
    // Enough players want to participate and the host has chosen a game
    // that should be initialized now.
    func handleGameInitialize(request: GameInitialize) {
        do {
            guard let gameFactory = self.appDelegate?.gameFactory else {
                os_log("[FRAMEWORK] Game Factory of App Delegate unexpectedly undefined.", type: .error)
                return
            }
            self.currentGameDelegate = try gameFactory.createPlayerGame(with: request.gameInfo)
            self.currentGameDelegate?.framework = self
            self.sendHandler?.sendToHost(message: GameInitialized())
        } catch {
            os_log("[FRAMEWORK] Error while instatiating a game: %@", type: .error, error.localizedDescription)
        }
    }
    
    // Tell the game to start.
    func handleGameStarts() throws {
        guard self.currentGameDelegate != nil else {
            os_log("[FRAMEWORK] currentGameDelegate is undefined in handleGameStarts()", type: .error)
            throw FrameworkError.weakVarUndefined
        }
        self.currentGameDelegate!.play()
    }
    
    // The game has ended and sent us the result (ranked players).
    // Tell the app to display this ("you have won/lost etc").
    func handleGameResult(request: GameResult) {
        self.currentGameDelegate?.terminate {
            self.currentGameDelegate = nil
        }
        self.appDelegate?.updateGameStatistics(request.players)
    }
    
    // Send a game message to the host. Should only be used by games.
    public func sendGameDataToHost<T>(message: T, sendMode: SessionSendDataMode?) where T: Codable {
        self.sendHandler?.sendGameDataToHost(message: message, sendMode: sendMode ?? .reliable)
    }
}

extension PlayerFrameworkImpl: ConnectivityDelegate {
    
    // When connected to a host, tell the app to display this and stop searching for nearby hosts.
    // When disconnected, tell the app to display this and start searching for nearby hosts again.
    func session(_ peer: Peer, didChange state: SessionState) {
        switch state {
        case .connected:
            self.connectivity.stopBrowsing()
            self.connectedHost = peer
            self.appDelegate?.showConnected(to: peer)
        case .notConnected:
            self.appDelegate?.showDisconnected(from: peer)
            self.connectedHost = nil
            self.connectivity.startBrowsing()
        default:
            return
        }
    }
    
    // Let the messageHandler handle messages received from the host.
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
    
    // Let the app know that a nearby host was found,
    // so it can be displayed and the player can choose to connect.
    func browser(foundPeer peer: Peer) {
        self.appDelegate?.showFoundHost(peer)
    }
    
    // Let the app know that a nearby host no longer exists,
    // so it can stop displaying it.
    func browser(lostPeer peer: Peer) {
        self.appDelegate?.showLostHost(peer)
    }
}
