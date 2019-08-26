//
//  HostDrawViewModel+HostVIewModelAdapter.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 25.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import os.log
import UIKit

//extension HostDrawViewModel: HostViewModelAdapter {
//
//    func nextImage(_ image: String) {
//        next(image: image)
//    }
//
//    func embedInstructionsViewController(in viewController: UIViewController) {
//        switchViewController(old: nil, new: hostInstructionsViewController, in: viewController)
//    }
//
//    func embedDrawViewController(in viewController: UIViewController) {
//        switchViewController(old: hostInstructionsViewController, new: hostDrawViewController, in: viewController)
//    }
//
//    func embedResultViewController(in viewController: UIViewController) {
//        switchViewController(old: hostDrawViewController, new: hostResultViewController, in: viewController)
//    }
//
//    func removeResultController(from viewController: UIViewController) {
//        switchViewController(old: hostResultViewController, new: nil, in: viewController)
//    }
//
//}

// TODO: own file
extension HostDrawViewModel {
    // Switches the view (app > instructions > game > result > app).
    func switchViewController(old: UIViewController?, new: UIViewController?, in container: UIViewController) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            
            if (old != nil) {
                // remove old view
                old!.view.removeFromSuperview()
                old!.removeFromParent()
            }
            
            if (new != nil) {
                // add new view
                container.addChild(new!.self)
                container.view.addSubview(new!.view)
                
                // add constraints
                new!.view.translatesAutoresizingMaskIntoConstraints = false
                new!.view.topAnchor.constraint(equalTo: container.view.topAnchor).isActive = true
                new!.view.bottomAnchor.constraint(equalTo: container.view.bottomAnchor).isActive = true
                new!.view.leadingAnchor.constraint(equalTo: container.view.leadingAnchor).isActive = true
                new!.view.trailingAnchor.constraint(equalTo: container.view.trailingAnchor).isActive = true
            }
            
        }
        
    }
}
