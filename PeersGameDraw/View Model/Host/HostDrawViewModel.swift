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
    
    var images: [String]?
    weak var drawViewModelDelegate: HostDrawViewModelDelegate?
    
    var currentImageIndex: Int
    
    init() {
        currentImageIndex = 0
        next()
    }
    
    func next() {
        let nextImage = images?[currentImageIndex]
        guard let image = nextImage else {
            os_log("No images", type: .error)
            return
        }
        drawViewModelDelegate?.didUpdate(image: image)
        
        currentImageIndex += 1
    }
}
