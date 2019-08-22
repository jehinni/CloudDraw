import Foundation

// Defines the functions that App and Games can call on the player framework.
public protocol PlayerFramework {
    
    // App delegate that the PlayerFramework can interact with to show things onscreen.
    var appDelegate: PlayerAppDelegate? { get set }
    
    // Make player app start browsing for available hosts.
    // Should be called as soon as a peer chose to be a player
    func startBrowsing()
    
    // Invite a host to connect (he will always accept if maximum number of players not reached).
    func connectToHost(peer: Peer) throws
    
    // Disconnect the player from any connections.
    func disconnect()
    
    // Make player app stop browsing for available hosts.
    // Should be called as soon as a player connected to a host.
    func stopBrowsing()
    
    // Tell the host that this player wants to start a game.
    func requestGame(peer: Peer)
    
    // Tell the host that this player wants to participate in the next game.
    func joinNextGame()
    
    // Tell the player that join next game was successful
    func handleJoinedNextGameSuccessfully()
    
    // Tell the current game to terminate
    func terminateGame(completionHandler: @escaping () -> Void)
    
    // Send a message to the host with context game.
    // This function should only be used by games.
    func sendGameDataToHost<T>(message: T, sendMode: SessionSendDataMode?) where T: Codable
}
