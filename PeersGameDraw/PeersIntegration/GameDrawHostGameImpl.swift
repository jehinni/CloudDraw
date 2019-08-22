//
//  GameDrawHostGameImpl.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework

class GameDrawHostGameImpl: HostGame {
    var framework: HostFramework?
    
    var gamePlayers: [GamePlayer] = []
    
    weak var containerViewController: UIViewController?
    
    init(parentViewController: UIViewController) {
        containerViewController = parentViewController
    }
    
    // Handles messages received from players.
    func handle(message: Data, ofType: String, from peer: Peer) {
        
    }
    
    // Called by the Framework.
    func prepare(players: [Player]) {
        
    }
    
    // Called by the Framework.
    // Showing instruction views for the specified time.
    // Then switching views and starting the drawing timer.
    func play() {
        
    }
    
    // Called by the Framework. Returns the ranked players (winner to looser)
    // after showing the result view.
    func evaluate() -> [GamePlayer] {
        return gamePlayers
    }
    
    // Forces the game to stop, even mid-lifecycle.
    func terminate(completionHandler: @escaping () -> Void) {
        
    }
    
    // Handle a player exiting during the game.
    func lostPlayer(_ player: Player) {
        
    }
    
}
