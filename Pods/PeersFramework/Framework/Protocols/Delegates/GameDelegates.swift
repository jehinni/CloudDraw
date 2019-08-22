import Foundation

/// These protocols should be implemented by every Game.
/// They define delegate methods that will be called
/// by the framework if the peer is a host/player.

public protocol HostGame {
    
    var framework: HostFramework? { get set }
    
    // Handle a message that was sent to this host by a player.
    func handle(message: Data, ofType: String, from peer: Peer)
    
    // Here, the game should prepare any requirements it needs to be played.
    // This could mean presenting a ViewController (most certainly neccessary),
    // calculating something or sending data to your clients.
    // This function should not return until the preparation is finished.
    func prepare(players: [Player])
    
    // Here, the game should start its gameplay.
    // This function should not return until the gameplay is finished.
    func play()
    
    // This function is called if a player was disconnected
    // while the game is running. The game may need this information,
    // for example when waiting for every player to send some message back.
    func lostPlayer(_ player: Player)
    
    // Here, you should calculate the ranking of all players
    // and return the ranked players (from winner to loser).
    func evaluate() -> [GamePlayer]
    
    // The game should remove any views from the screen
    // so that the HostGame can be dereferenced.
    func terminate(completionHandler: @escaping () -> Void)
}

public protocol PlayerGame {
    
    var framework: PlayerFramework? { get set }
    
    // Handle a message that was sent to this player by the host.
    func handle(message: Data, ofType: String)
    
    // Here, the game should start its gameplay.
    // This function should not return until the gameplay is finished.
    func play()
    
    // The game should remove any views from the screen
    // so that the PlayerGame can be dereferenced.
    func terminate(completionHandler: @escaping () -> Void)
}
