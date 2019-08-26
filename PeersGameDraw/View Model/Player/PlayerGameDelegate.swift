//
//  PlayerGameDelegate.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

protocol PlayerGameDelegate: AnyObject {
    func didReceive(prediction: String)
    func didUpdate(points: Int)
}
