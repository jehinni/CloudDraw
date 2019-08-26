//
//  GameDrawPlayerGameImpl+SwitchViewController.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit
import os.log

extension GameDrawPlayerGameImpl {
    // Switches the view (app > instructions > game > result > app).
    func switchViewController(old: UIViewController?, new: UIViewController?, with completionHandler: @escaping () -> Void = {}) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            if (new != nil && old == nil) {
                // from app
                self.containerViewController.present(new!, animated: true, completion: nil)
            } else if (old != nil && new != nil) {
                // switch view in game
                old!.present(new!, animated: false, completion: nil)
            } else if (old != nil && new == nil) {
                // back to app
                self.containerViewController.dismiss(animated: true, completion: nil)
            }
            completionHandler()
        }
    }
}
