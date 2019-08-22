import Foundation

// Errors occuring in the Framework.
enum FrameworkError: Error {
    case notEnoughPlayers
    case tooManyPlayers
    case noGamesFound
    case couldNotFindPlayerByPeer
    case weakVarUndefined
    case playersUndefined
    case playingPlayersUndefined
}
