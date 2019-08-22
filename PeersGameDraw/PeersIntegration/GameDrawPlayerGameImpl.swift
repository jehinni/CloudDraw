//
//  GameDrawPlayerGameImpl.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework
import os.log

class GameDrawPlayerGameImpl: PlayerGame {
    var framework: PlayerFramework?
    
    weak var containerViewController: UIViewController?
    var playerInstructionsViewController: PlayerInstructionsViewController
    var playerDrawViewController: PlayerDrawViewController
    var playerResultViewController: PlayerResultViewController
    
    var points = 0
    var finalGamePlayer: GamePlayer?
    var finalRankingPosition: Int?
    
    init(parentViewController: UIViewController) {
        containerViewController = parentViewController
        
        let storyboard = UIStoryboard(name: "GameQuizPlayer", bundle: Bundle(for: BundleToken.self))
        playerInstructionsViewController = storyboard.instantiateViewController(withIdentifier: "PlayerInstructionsViewController") as! PlayerInstructionsViewController
        playerDrawViewController = storyboard.instantiateViewController(withIdentifier: "PlayerDrawViewController") as! PlayerDrawViewController
        playerResultViewController = storyboard.instantiateViewController(withIdentifier: "PlayerResultViewController") as! PlayerResultViewController
    }
    
    deinit {
        os_log("[GAME DRAW] deinit", type: .debug)
    }
    
    // HostGame methods
    
    func handle(message: Data, ofType: String) {
        do {
            // TODO: handle messages
            os_log("[GAME Draw] Received message %s.", type: .debug, ofType)
            switch ofType {
            case "\(GameStartMessage.self)":
                switchViewController(old: playerInstructionsViewController, new: playerDrawViewController)
            case "\(SubjectMessage.self)":
                let data = try MessageWrapper.decodeData(type: SubjectMessage.self, data: message)
            case "\(ResultRequestMessage.self)":
                endGame()
            case "\(RankingPositionMessage.self)":
                let data = try MessageWrapper.decodeData(type: RankingPositionMessage.self, data: message)
                finalGamePlayer = data.gamePlayer
                finalRankingPosition = data.rankingPosition
            case "\(GameEndMessage.self)":
                switchViewController(old: playerDrawViewController, new: playerResultViewController)
            default:
                os_log("[GAME QUIZ] Received unknown message.", type: .error)
            }
        } catch {
            os_log("[GAME QUIZ] Failed to decode message of type %s: %@", type: .error, ofType, error.localizedDescription)
        }
    }
    
    // Called by the framework.
    // Show the instructions view to take (partial) view control from the Peers App.
    func play() {
        
    }
    
    // Called by the framework.
    // Remove the game view to pass back view control to the Peers App.
    func terminate(completionHandler: @escaping () -> Void) {
        
    }
    
    // handler?? methods
    
    // Ends game: Stops timer and asks the players to send their result (final points).
    func endGame() {
        os_log("[GAME DRAW] Ending game: sending player result (%d points) to the host.", type: .debug, points)
        self.framework?.sendGameDataToHost(message: ResultMessage(points: points), sendMode: .reliable)
    }
    
    
}

// TODO: own file
extension GameDrawPlayerGameImpl {
    // Switches the view (app > instructions > game > result > app).
    private func switchViewController(old: UIViewController?, new: UIViewController?, completionHandler: @escaping () -> Void = {}) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            guard let parentViewController = self.containerViewController else {
                os_log("[GAME DRAW] Cannot switch views as parent view controller is dereferenced", type: .error)
                return
            }
            if (new != nil && old == nil) {
                // from app
                parentViewController.present(new!, animated: true, completion: nil)
            } else if (old != nil && new != nil) {
                // switch view in game
                old!.present(new!, animated: false, completion: nil)
            } else if (old != nil && new == nil) {
                // back to app
                parentViewController.dismiss(animated: true, completion: nil)
            }
            completionHandler()
        }
    }
}

private final class BundleToken {}
