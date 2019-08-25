//
//  HostGameDelegate.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework

protocol HostGameDelegate: class {
    
    var players: [Player] { get }
    var gamePlayerCurrentAnswers: [Int] { get set }
    
    var rankedPlayers: [RankingPositionMessage] { get }
}

