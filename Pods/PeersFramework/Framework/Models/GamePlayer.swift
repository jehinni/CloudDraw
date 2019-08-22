import Foundation

// A game player is used only in games and contains
// a player with his current points and end points result.
public class GamePlayer: NSObject, Codable {
    public let player: Player
    public var points: Int?
    public var result: Int?
    public init(from player: Player) {
        self.player = player
    }
}
