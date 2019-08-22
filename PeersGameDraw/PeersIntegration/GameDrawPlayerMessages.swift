//
//  GameDrawPlayerMessages.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework

struct PointsMessage: Codable {
    let points: Int
    init(points: Int) {
        self.points = points
    }
}

struct ResultMessage: Codable {
    let points: Int
    init(points: Int) {
        self.points = points
    }
}
