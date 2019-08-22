import Foundation

class RankingGenerator: NSObject {
    
    private let rankedPlayers: [(key: Int, value: [GamePlayer])]
    
    init(for gamePlayers: [GamePlayer]) {
        self.rankedPlayers = Dictionary(grouping: gamePlayers, by: { $0.result! }).sorted(by: { $0.key > $1.key })
    }
    
    /// Sorts players by (game) points and groups those with equal ones.
    /// Then caluclates (global) points of each player accordingly.
    /// Every player gets points between -3 and 3,
    /// so that the Ranking is always balanced (sum of all rankings = 0).
    /// - Parameter players: game players with their result (final game points)
    func generateRanking () throws {
        switch self.rankedPlayers.count {
        case 1: break
        case 2:
            self.givePoints(points: 3, toPlayersWithIndex: 0)
            self.givePoints(points: -3, toPlayersWithIndex: 1)
        case 3:
            self.givePoints(points: 3, toPlayersWithIndex: 0)
            self.givePoints(points: -3, toPlayersWithIndex: 2)
        case 4:
            self.givePoints(points: 3, toPlayersWithIndex: 0)
            self.givePoints(points: 1, toPlayersWithIndex: 1)
            self.givePoints(points: -1, toPlayersWithIndex: 2)
            self.givePoints(points: -3, toPlayersWithIndex: 3)
        case 5:
            self.givePoints(points: 3, toPlayersWithIndex: 0)
            self.givePoints(points: 1, toPlayersWithIndex: 1)
            self.givePoints(points: -1, toPlayersWithIndex: 3)
            self.givePoints(points: -3, toPlayersWithIndex: 4)
        case 6:
            self.givePoints(points: 3, toPlayersWithIndex: 0)
            self.givePoints(points: 2, toPlayersWithIndex: 1)
            self.givePoints(points: 1, toPlayersWithIndex: 2)
            self.givePoints(points: -1, toPlayersWithIndex: 3)
            self.givePoints(points: -2, toPlayersWithIndex: 4)
            self.givePoints(points: -3, toPlayersWithIndex: 5)
        case 7:
            self.givePoints(points: 3, toPlayersWithIndex: 0)
            self.givePoints(points: 2, toPlayersWithIndex: 1)
            self.givePoints(points: 1, toPlayersWithIndex: 2)
            self.givePoints(points: -1, toPlayersWithIndex: 4)
            self.givePoints(points: -2, toPlayersWithIndex: 5)
            self.givePoints(points: -3, toPlayersWithIndex: 6)
        default:
            throw self.rankedPlayers.count > 7 ? FrameworkError.tooManyPlayers : FrameworkError.notEnoughPlayers
        }
    }
    
    private func givePoints(points: Int, toPlayersWithIndex: Int) {
        for player in self.rankedPlayers[toPlayersWithIndex].value {
            player.player.points += points
        }
    }
}
