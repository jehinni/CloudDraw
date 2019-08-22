//
//  GameDrawPlayerGameImpl.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework
import os.log

class GameDrawPlayerGameImpl: PlayerGame {
    var framework: PlayerFramework?
    
    weak var containerViewController: UIViewController?
    var playerInstructionsViewController: PlayerInstructionsViewController
    var playerDrawViewController: PlayerDrawViewController
    var playerResultViewController: PlayerResultViewController
    
    init(parentViewController: UIViewController) {
        containerViewController = parentViewController
        
        let storyboard = UIStoryboard(name: "GameQuizPlayer", bundle: Bundle(for: BundleToken.self))
        playerInstructionsViewController = storyboard.instantiateViewController(withIdentifier: "PlayerInstructionsViewController") as! PlayerInstructionsViewController
        playerDrawViewController = storyboard.instantiateViewController(withIdentifier: "PlayerDrawViewController") as! PlayerDrawViewController
        playerResultViewController = storyboard.instantiateViewController(withIdentifier: "PlayerResultViewController") as! PlayerResultViewController
    }
    
    deinit {
        os_log("[GAME DRAW] deinit", type: .debug)
    }
    
    func handle(message: Data, ofType: String) {
        
    }
    
    // Called by the framework.
    // Show the instructions view to take (partial) view control from the Peers App.
    func play() {
        
    }
    
    // Called by the framework.
    // Remove the game view to pass back view control to the Peers App.
    func terminate(completionHandler: @escaping () -> Void) {
        
    }
    
    
}

// TODO: own file
extension GameDrawPlayerGameImpl {
    // Switches the view (app > instructions > game > result > app).
    private func switchViewController(old: UIViewController?, new: UIViewController?, completionHandler: @escaping () -> Void = {}) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            guard let parentViewController = self.containerViewController else {
                os_log("[GAME DRAW] Cannot switch views as parent view controller is dereferenced", type: .error)
                return
            }
            if (new != nil && old == nil) {
                // from app
                parentViewController.present(new!, animated: true, completion: nil)
            } else if (old != nil && new != nil) {
                // switch view in game
                old!.present(new!, animated: false, completion: nil)
            } else if (old != nil && new == nil) {
                // back to app
                parentViewController.dismiss(animated: true, completion: nil)
            }
            completionHandler()
        }
    }
}

private final class BundleToken {}
