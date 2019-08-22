import Foundation

// Defines the functions that App and Games can call on the host framework.
public protocol HostFramework {
    
    // App delegate that the HostFramework can interact with to show things onscreen.
    var appDelegate: HostAppDelegate? { get set }

    // Send a game message to all or some playing players.
    // This function should only be used by games.
    func sendGameDataToPlayers<T>(message: T, to players: [Player]?, sendMode: SessionSendDataMode?) where T: Codable
    
    // End the gameplay.
    // This function should only be used by games.
    func finishGame()
    
    // Disconnect the host from any connections.
    func disconnect()
}
