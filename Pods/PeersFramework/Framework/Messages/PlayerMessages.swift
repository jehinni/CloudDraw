import Foundation

/// Messages sent from players to host:

// Let the host know that the player wants to start playing.
struct GameSessionRequest: Codable {
    let peer: Peer
    init(peer: Peer) {
        self.peer = peer
    }
}

// Let the host know that the player wants to participate
// in the next game.
struct JoinNextGame: Codable {}

// Let the host know that the player has initialized the game
// and is ready for game preparation.
struct GameInitialized: Codable {}

