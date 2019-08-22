import Foundation

class GameCompatibilityChecker {
    
    private let players: [Player]
    
    init(for players: [Player]) {
        self.players = players
    }
    
    // Pick a game that every peer can play since
    // they all have the same version of it.
    // If no common game can be found, an error will be thrown.
    func randomGame() throws -> GameInfo {
        
        // Flatten the players to a set containing all games they support.
        let gameSets = self.generateGameSets()
        
        // If no game sets are available, throw an error.
        try self.checkSize(of: gameSets)
        
        // Intersect all game sets with each other.
        // In the end, "intersected" only contains games that are
        // supported in that exact version by all players.
        let intersected = self.intersect(all: gameSets)
        
        // If no intersected games are left, throw an error.
        try self.checkSize(of: intersected)
        
        return intersected.randomElement()!
    }
    
    private func generateGameSets() -> [Set<GameInfo>] {
        return self.players
            .map({ $0.peer.supportedGames })
            .filter({ $0.count > 0 })
            .map({ Set($0) })
    }
    
    private func checkSize<T>(of collection: T) throws where T: Collection {
        if collection.count <= 0 {
            throw FrameworkError.noGamesFound
        }
    }
    
    private func intersect<T>(all elements: [Set<T>]) -> Set<T> where T: Equatable {
        var intersected = elements[elements.startIndex]
        for i in elements.startIndex + 1..<elements.count {
            intersected = intersected.intersection(elements[i])
        }
        return intersected
    }
}
