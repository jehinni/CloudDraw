import Foundation

// Implemented by the App to generate a Game for the Framework.
// The game info provides the game's name and version.
public protocol GameFactory {
    
    func createHostGame(with gameInfo: GameInfo) throws -> HostGame
    
    func createPlayerGame(with gameInfo: GameInfo) throws -> PlayerGame
}
