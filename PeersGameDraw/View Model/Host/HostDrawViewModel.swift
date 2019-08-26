//
//  HostDrawViewModel.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import os.log
import UIKit

class HostDrawViewModel: HostDrawViewModelProtocol {
    
    var hostInstructionsViewController: HostInstructionsViewController
    var hostDrawViewController: HostDrawViewController
    var hostResultViewController: HostResultViewController
    
    var hostGameDelegate: HostGameDelegate?
    
    init() {
        // TODO: inject
        hostInstructionsViewController = ViewControllerFactory.createHostInstructionsViewController()
        hostDrawViewController = ViewControllerFactory.createHostDrawViewController()
        hostResultViewController = ViewControllerFactory.createHostResultViewController()
        
    }
    
    var image: String?
    weak var drawViewModelDelegate: HostDrawViewModelDelegate?
    
    func next(image: String) {
        self.image = image
        os_log("viewModel image: %@", type: .debug, image)
        drawViewModelDelegate?.didUpdate(image: image)
    }
    
    func embedInstructionsViewController(in viewController: UIViewController) {
        switchViewController(old: nil, new: hostInstructionsViewController, in: viewController)
    }
    
    func embedDrawViewController(in viewController: UIViewController) {
        switchViewController(old: hostInstructionsViewController, new: hostDrawViewController, in: viewController)
    }
    
    func embedResultViewController(in viewController: UIViewController) {
        switchViewController(old: hostDrawViewController, new: hostResultViewController, in: viewController)
    }
    
    func removeResultController(from viewController: UIViewController) {
        switchViewController(old: hostResultViewController, new: nil, in: viewController)
    }
    
}
