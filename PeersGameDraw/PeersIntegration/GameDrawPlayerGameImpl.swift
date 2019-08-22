//
//  GameDrawPlayerGameImpl.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework

class GameDrawPlayerGameImpl: PlayerGame {
    var framework: PlayerFramework?
    
    func handle(message: Data, ofType: String) {
        <#code#>
    }
    
    // Called by the framework.
    // Show the instructions view to take (partial) view control from the Peers App.
    func play() {
        <#code#>
    }
    
    // Called by the framework.
    // Remove the game view to pass back view control to the Peers App.
    func terminate(completionHandler: @escaping () -> Void) {
        <#code#>
    }
    
    
}
