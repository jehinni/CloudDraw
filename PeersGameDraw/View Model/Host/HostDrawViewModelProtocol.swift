//
//  HostDrawViewModelProtocol.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

protocol HostDrawViewModelProtocol {

    var drawViewModelDelegate: HostDrawViewModelDelegate? { get set }
    var hostGameDelegate: HostGameDelegate? { get set }
    var image: String? { get set }
    
    func next(image: String)
    
}
