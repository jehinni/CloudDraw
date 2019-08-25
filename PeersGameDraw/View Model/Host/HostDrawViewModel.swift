//
//  HostDrawViewModel.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import os.log

class HostDrawViewModel: HostDrawViewModelProtocol {
    
    var image: String?
    weak var drawViewModelDelegate: HostDrawViewModelDelegate?
    
    func next(image: String) {
        // TODO: no self
        self.image = image
        drawViewModelDelegate?.didUpdate(image: image)
    }
    
}
