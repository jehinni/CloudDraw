//
//  HostDrawViewModelProtocol.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

protocol HostDrawViewModelProtocol {
    
    var drawViewModelDelegate: HostDrawViewModelDelegate? { get set }
    var currentImageIndex: Int { get }
    var images: [String]? { get set }
    
    func next()
    
}
