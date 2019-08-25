//
//  PlayerDrawViewModel+PlayerViewModelAdapter.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import os.log
import UIKit

extension PlayerDrawViewModel: PlayerViewModelAdapter {
    
    func nextImage(_ image: String) {
        next(image: image)
    }
    
    func embedInstructionsViewController(in viewController: UIViewController, with completionHandler: @escaping () -> Void = {}) {
        switchViewController(old: nil, new: playerInstructionsViewController, in: viewController, with: completionHandler)
    }
    
    func embedDrawViewController(in viewController: UIViewController, with completionHandler: @escaping () -> Void = {}) {
        switchViewController(old: playerInstructionsViewController, new: playerDrawViewController, in: viewController, with: completionHandler)
    }
    
    func embedResultViewController(in viewController: UIViewController, with completionHandler: @escaping () -> Void = {}) {
        switchViewController(old: playerDrawViewController, new: playerResultViewController, in: viewController, with: completionHandler)
    }
    
    func removeResultController(from viewController: UIViewController, with completionHandler: @escaping () -> Void = {}) {
        switchViewController(old: playerResultViewController, new: nil, in: viewController, with: completionHandler)
    }
    
    
}

// TODO: own file
extension PlayerDrawViewModel {
    // Switches the view (app > instructions > game > result > app).
    private func switchViewController(old: UIViewController?, new: UIViewController?, in container: UIViewController, with completionHandler: @escaping () -> Void = {}) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            
            if (new != nil && old == nil) {
                // from app
                container.present(new!, animated: true, completion: nil)
            } else if (old != nil && new != nil) {
                // switch view in game
                old!.present(new!, animated: false, completion: nil)
            } else if (old != nil && new == nil) {
                // back to app
                container.dismiss(animated: true, completion: nil)
            }
            completionHandler()
        }
    }
}
