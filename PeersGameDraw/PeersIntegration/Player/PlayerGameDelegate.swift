//
//  PlayerGameDelegate.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework

protocol PlayerGameDelegate: AnyObject {
    
    var finalGamePlayer: GamePlayer? { get }
    var finalRankingPosition: Int? { get }
    
    func didReceive(prediction: String)
    func didUpdate(points: Int)
}
