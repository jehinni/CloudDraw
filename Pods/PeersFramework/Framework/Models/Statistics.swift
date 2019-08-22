import Foundation

public class Statistics: Codable {
    
    public var gamesWon: Int
    public var gamesPlayed: Int
    
    public init(gamesWon: Int, gamesPlayed: Int) {
        self.gamesWon = gamesWon
        self.gamesPlayed = gamesPlayed
    }
    
    public static func decode(_ data: Data) throws -> Statistics {
        return try PropertyListDecoder().decode(Statistics.self, from: data)
    }
    
    public func encode() throws -> Data {
        return try PropertyListEncoder().encode(self)
    }
    
}
