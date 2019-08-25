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
        
        hostInstructionsViewController = ViewControllerFactory.createHostInstructionsViewController()
        hostDrawViewController = ViewControllerFactory.createHostDrawViewController()
        hostResultViewController = ViewControllerFactory.createHostResultViewController()
        
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
