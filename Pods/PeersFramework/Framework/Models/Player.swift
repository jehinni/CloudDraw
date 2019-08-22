import Foundation

// A player contains a peer object as well as further
// player-specific information (that hosts don't need).
public class Player: NSObject, Codable {
    
    public var peer: Peer
    public var points: Int
    public var ranking: Int
    
    init(peer: Peer) {
        self.peer = peer
        self.points = 0
        self.ranking = 0
    }
}
