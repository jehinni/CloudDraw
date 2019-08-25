//
//  HostDrawViewModel+HostVIewModelAdapter.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 25.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

extension HostDrawViewModel: HostViewModelAdapter {
    
    func next(image: String) {
        next()
    }
    
    var randomImages: [String]? {
        get {
            return images
        }
        set {
            images = newValue
        }
    }
}
