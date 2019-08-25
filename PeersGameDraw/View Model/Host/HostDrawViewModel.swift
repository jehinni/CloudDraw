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
    
    init() {
        // TODO: instead of initialising viewControllers, call them via delegate calls
        let storyboard = UIStoryboard(name: "GameDrawHost", bundle: Bundle(for: BundleToken.self))
        
        hostInstructionsViewController = storyboard.instantiateViewController(withIdentifier: "HostInstructionsViewController") as! HostInstructionsViewController
        hostDrawViewController = storyboard.instantiateViewController(withIdentifier: "HostDrawViewController") as! HostDrawViewController
        hostResultViewController = storyboard.instantiateViewController(withIdentifier: "HostResultViewController") as! HostResultViewController
        
    }
    
    var image: String?
    weak var drawViewModelDelegate: HostDrawViewModelDelegate?
    
    func next(image: String) {
        // TODO: no self
        self.image = image
        os_log("viewModel image: %@", type: .debug, image)
        drawViewModelDelegate?.didUpdate(image: image)
    }
    
}

private final class BundleToken {}
