import Foundation

// Defines a game by its name (e.g. class reference of the game)
// and its version (e.g. defined in game bundle infos).
public struct GameInfo: Codable, Equatable, Hashable {
    
    public let name: String
    public let version: String
    
    public init(name: String, version: String) {
        self.name = name
        self.version = version
    }
    
    public static func == (lhs: GameInfo, rhs: GameInfo) -> Bool {
        return lhs.name == rhs.name && lhs.version == rhs.version
    }
}
