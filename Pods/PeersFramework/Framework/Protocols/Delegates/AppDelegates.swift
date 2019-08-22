import Foundation

/// These delegate protocols should be implemented by the App.
/// They are called by the framework and provide
/// the host/player App with info to display.

public protocol HostAppDelegate: AnyObject {
    
    var gameFactory: GameFactory? { get }
    
    // A new player connected to the host.
    func showNewPlayerConnected(_ player: Player)
    
    // A player has disconnected from the host and was put in standby mode.
    func showPlayerChangedToStandby(_ player: Player)
    
    // A standby player has been deleted because some time has passed.
    func showStandbyPlayerDeleted(_ player: Player)
    
    // No further players can connect to the game session because the max number was reached.
    func showConnectionsNotPossible()
    
    // Further players can connect to the game sesseion again because a player disconnected.
    func showConnectionsPossible()
    
    // A game is about to start. The startAt Date
    // may be used to count down until the game starts.
    func showGameCouldStartSoon(startAt: Date)
    
    // A player said they want to participate in the next game.
    func showPlayerJoinedGame(_ player: Player)
    
    // The game could not be started because too few players wanted to participate.
    func showGameCannotStartTooFewPlayers()
    
    // A game has ended and the players have a new score.
    func showRanking(for players: [Player])
	
	// After every game, reset the playing players, so every player
	// has to choose again whether he wants to participate in the next game.
	func resetPlayingPlayers()
}

public protocol PlayerAppDelegate: AnyObject {
	
    var gameFactory: GameFactory? { get }

    // A nearby host was found and should be displayed to be able to connect.
    func showFoundHost(_ host: Peer)
	
	// A nearby host is no longer there and should be removed in App's display.
	func showLostHost(_ host: Peer)
    
    // The connection to a host was established.
    func showConnected(to host: Peer)
    
    // The connection to a host was lost.
    func showDisconnected(from host: Peer)
	
    // A game is possible since at least two players are connected.
    // (A "let's play" button should be shown.)
    func showGamePossible()
	
	// A game is no longer possible, e.g. because too few players are connected.
	// (The "let's play" button should no longer be shown or greyed out.)
    func showGameNotPossible()
    
    // Someone wants to start a game and asks the player if they want to join.
    // The delegate should now ask the user if they want to play.
    // If yes, accept the game invitation by calling the provided function on the Framework.
    func showGameCouldStartSoon(at: Date)
    
    /// Someone wants to start a game and asks the host if this is possible
    func showAcceptGameRequest(at: Date)
    
    func joinedNextGameSuccessfully()
    
    // A player requested a game session to start, but not enough players joined.
    func showGameCannotStartTooFewPlayers()
    
    // A player receives information about the game results and can update the personal game statistics
    func updateGameStatistics(_ gameResults: [Player])
}
