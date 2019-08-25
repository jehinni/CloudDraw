//
//  HostDrawViewModel+HostVIewModelAdapter.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 25.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

extension HostDrawViewModel: HostViewModelAdapter {
    
    func nextImage(_ image: String) {
        next(image: image)
    }
    
    var randomImage: String? {
        get {
            return image
        }
        set {
            image = newValue
        }
    }
}
