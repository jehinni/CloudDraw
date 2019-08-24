//
//  HostDrawViewModelDelegate.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 25.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

protocol HostDrawViewModelDelegate: AnyObject {
    func didUpdate(image: String)
}
