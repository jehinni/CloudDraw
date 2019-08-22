//
//  GameDrawHostMessages.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework

struct SubjectMessage: Codable {
    let drawSubject: String
    init(subject: String) {
        drawSubject = subject
    }
}

struct GameStartMessage: Codable {
    
}

struct ResultRequestMessage: Codable {
    
}

struct RankingPositionMessage: Codable {
    let gamePlayer: GamePlayer
    let rankingPosition: Int
    init(_ gamePlayer: GamePlayer, _ rankingPosition: Int) {
        self.gamePlayer = gamePlayer
        self.rankingPosition = rankingPosition
    }
}

struct GameEndMessage: Codable {
    
}
