import Foundation

/// Messages sent from host to players:

// Let players know that a game would be possible since
// enough players have joined the game session.
struct GamePossible: Codable {}

// Let players know that a game is no longer possible,
// e.g. because a player disconnected.
struct GameNotPossible: Codable {}

// Let players know a game will start soon (at the given date)
// if there are enough players that want to participate.
struct GameCouldStartSoon: Codable {
    let startAt: Date
    init(startAt: Date) {
        self.startAt = startAt
    }
}

// Let player who wants to start a game and sends a request to the framework know
// that a game is possible and can be started
struct AcceptGameRequest: Codable {
    let startAt: Date
    init(startAt: Date) {
        self.startAt = startAt
    }
}

// Let the player know that join next game was successful
struct JoinNextGameSuccessful: Codable{}

// Let players know that the gameplay could not be started
// because not enough players joined.
struct GameCannotStartTooFewPlayers: Codable {}

// Let players know they should initialize an instance
// of the game with the given name.
struct GameInitialize: Codable {
    let gameInfo: GameInfo
    init(gameInfo: GameInfo) {
        self.gameInfo = gameInfo
    }
}

// Let players know they should trigger the gameplay start.
struct GameStarts: Codable {}

// Inform the players about the game result after game end.
// The players are ordered from winner to looser.
struct GameResult: Codable {
    let players: [Player]
    init(players: [Player]) {
        self.players = players
    }
}
