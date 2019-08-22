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
    
    // Handles messages received from players.
    func handle(message: Data, ofType: String, from peer: Peer) {
        <#code#>
    }
    
    // Called by the Framework.
    func prepare(players: [Player]) {
        <#code#>
    }
    
    // Called by the Framework.
    // Showing instruction views for the specified time.
    // Then switching views and starting the drawing timer.
    func play() {
        <#code#>
    }
    
    // Called by the Framework. Returns the ranked players (winner to looser)
    // after showing the result view.
    func evaluate() -> [GamePlayer] {
        <#code#>
    }
    
    // Forces the game to stop, even mid-lifecycle.
    func terminate(completionHandler: @escaping () -> Void) {
        <#code#>
    }
    
    // Handle a player exiting during the game.
    func lostPlayer(_ player: Player) {
        <#code#>
    }
    
}
