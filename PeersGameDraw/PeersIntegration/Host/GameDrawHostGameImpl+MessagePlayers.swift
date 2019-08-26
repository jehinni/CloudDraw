//
//  GameDrawHostGameImpl+MessagePlayers.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import os.log

extension GameDrawHostGameImpl {
    func messageToPlayers(message: String?) {
        // send view change message to players
        if (message != nil) {
            switch message! {
            case "GameStartMessage":
                self.framework?.sendGameDataToPlayers(message: GameStartMessage(), to: self.players, sendMode: .reliable)
            case "GameEndMessage":
                self.framework?.sendGameDataToPlayers(message: GameEndMessage(), to: self.players, sendMode: .reliable)
            default:
                os_log("[GAME DRAW] Unknown message type in messageToPlayers(): %s", type: .debug, message!)
            }
        }
    }
}
