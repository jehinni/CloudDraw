import Foundation

// This class represents a device that can connect
// to other peers using the Connectivity protocol.
public class Peer: NSObject, Codable {
    
    public let id: String
    public var name: String
    public var profilePicture: String
    public var supportedGames: [GameInfo]
    
    public init(id: String, name: String, profilePicture: String, supportedGames: [GameInfo]) {
        self.id = id
        self.name = name
        self.profilePicture = profilePicture
        self.supportedGames = supportedGames
    }
    
    public func encode() throws -> Data {
        return try PropertyListEncoder().encode(self)
    }
    
    public static func decode(_ data: Data) throws -> Peer {
        return try PropertyListDecoder().decode(Peer.self, from: data)
    }
    
    public static func ==(p1: Peer, p2: Peer) -> Bool {
        return p1.id == p2.id
    }
}
