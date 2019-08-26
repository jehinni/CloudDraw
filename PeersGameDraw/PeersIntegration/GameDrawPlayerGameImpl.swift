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

class GameDrawPlayerGameImpl: PlayerGame, PlayerGameDelegate {
    var framework: PlayerFramework?
    
    unowned var containerViewController: UIViewController
    
    var points = 0
    var finalGamePlayer: GamePlayer?
    var finalRankingPosition: Int?
    
    var playerInstructionsViewController: PlayerInstructionsViewController
    var playerDrawViewController: PlayerDrawViewController
    var playerResultViewController: PlayerResultViewController
    
    init(parentViewController: UIViewController) {
        containerViewController = parentViewController
        
        playerInstructionsViewController = ViewControllerFactory.createPlayerInstructionsViewController()
        playerDrawViewController = ViewControllerFactory.createPlayerDrawViewController()
        playerResultViewController = ViewControllerFactory.createPlayerResultViewController()
        
        playerDrawViewController.drawViewModel = ViewModelFactory.createPlayerDrawViewModel(with: playerDrawViewController.mainImageView)
        playerDrawViewController.drawViewModel?.playerGameDelegate = self
        
    }
    
    deinit {
        os_log("[GAME DRAW] player deinit", type: .debug)
    }
    
    // PlayerGame methods
    
    func handle(message: Data, ofType: String) {
        do {
            // TODO: handle messages
            os_log("[GAME Draw] Received message %s.", type: .debug, ofType)
            switch ofType {
            case "\(GameStartMessage.self)":
                switchViewController(old: playerInstructionsViewController, new: playerDrawViewController, with: {})
            case "\(NextImageMessage.self)":
                let data = try MessageWrapper.decodeData(type: NextImageMessage.self, data: message)
                next(image: data.image)
            case "\(ResultRequestMessage.self)":
                endGame()
            case "\(RankingPositionMessage.self)":
                let data = try MessageWrapper.decodeData(type: RankingPositionMessage.self, data: message)
                finalGamePlayer = data.gamePlayer
                finalRankingPosition = data.rankingPosition
            case "\(GameEndMessage.self)":
                switchViewController(old: playerDrawViewController, new: playerResultViewController, with: {})
               
            default:
                os_log("[GAME DRAW] Received unknown message.", type: .error)
            }
        } catch {
            os_log("[GAME DRAW] Failed to decode message of type %s: %@", type: .error, ofType, error.localizedDescription)
        }
    }
    
    // Called by the framework.
    // Show the instructions view to take (partial) view control from the Peers App.
    func play() {
        os_log("[GAME DRAW] Play: showing instructions view.", type: .debug)
        switchViewController(old: nil, new: playerInstructionsViewController, with: {})
    }
    
    // Called by the framework.
    // Remove the game view to pass back view control to the Peers App.
    func terminate(completionHandler: @escaping () -> Void) {
        os_log("[GAME DRAW] Terminate: removing game view.", type: .debug)
        switchViewController(old: playerResultViewController, new: nil, with: completionHandler)
    }
    
    // Passes next image to draw
    func next(image: String) {
        os_log("[GAME DRAW] Setting and showing next image: %@", type: .debug, image)
        
        DispatchQueue.main.async {
            self.playerDrawViewController.next(image: image)
        }
        
    }
    
    // Ends game: Stops timer and asks the players to send their result (final points).
    func endGame() {
        os_log("[GAME DRAW] Ending game: sending player result (%d points) to the host.", type: .debug, points)
        framework?.sendGameDataToHost(message: ResultMessage(points: points), sendMode: .reliable)
    }
    
    // PlayerGameDelegate method
    
    func didReceive(prediction: String) {
        os_log("[GAME DRAW] Received prediction.", type: .debug)
        framework?.sendGameDataToHost(message: ImagePredictionMessage(prediction: prediction), sendMode: .reliable)
    }
    
    func didUpdate(points: Int) {
        os_log("[GAME DRAW] Update player points.", type: .debug)
        self.points = points
        framework?.sendGameDataToHost(message: ResultMessage(points: self.points), sendMode: .unreliable)
    }
    
    
}

extension GameDrawPlayerGameImpl {
    // Switches the view (app > instructions > game > result > app).
    func switchViewController(old: UIViewController?, new: UIViewController?, with completionHandler: @escaping () -> Void = {}) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            
            if (new != nil && old == nil) {
                // from app
                self.containerViewController.present(new!, animated: true, completion: nil)
            } else if (old != nil && new != nil) {
                // switch view in game
                old!.present(new!, animated: false, completion: nil)
            } else if (old != nil && new == nil) {
                // back to app
                self.containerViewController.dismiss(animated: true, completion: nil)
            }
            completionHandler()
        }
    }
}

private final class BundleToken {}
