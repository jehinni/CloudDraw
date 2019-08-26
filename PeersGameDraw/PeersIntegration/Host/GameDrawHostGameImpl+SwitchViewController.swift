//
//  GameDrawHostGameImpl+SwitchViewController.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit
import os.log

extension GameDrawHostGameImpl {
    // Switches the view (app > instructions > game > result > app).
    func switchViewController(old: UIViewController?, new: UIViewController?) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            
            if (old != nil) {
                // remove old view
                old!.view.removeFromSuperview()
                old!.removeFromParent()
            }
            
            if (new != nil) {
                // add new view
                self.containerViewController.addChild(new!.self)
                self.containerViewController.view.addSubview(new!.view)
                
                // add constraints
                new!.view.translatesAutoresizingMaskIntoConstraints = false
                new!.view.topAnchor.constraint(equalTo: self.containerViewController.view.topAnchor).isActive = true
                new!.view.bottomAnchor.constraint(equalTo: self.containerViewController.view.bottomAnchor).isActive = true
                new!.view.leadingAnchor.constraint(equalTo: self.containerViewController.view.leadingAnchor).isActive = true
                new!.view.trailingAnchor.constraint(equalTo: self.containerViewController.view.trailingAnchor).isActive = true
            }
            
        }
        
    }
}
