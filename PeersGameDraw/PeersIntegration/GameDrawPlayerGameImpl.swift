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
    
    var playerViewModel: PlayerDrawViewModelProtocol?
    
    var points = 0
    var finalGamePlayer: GamePlayer?
    var finalRankingPosition: Int?
    
    init(parentViewController: UIViewController) {
        containerViewController = parentViewController
        
        playerViewModel = ViewModelFactory.createPlayerDrawViewModel()
        playerViewModel?.playerGameDelegate = self
        
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
                playerViewModel?.embedDrawViewController(in: containerViewController, with: {})
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
                playerViewModel?.embedResultViewController(in: containerViewController, with: {})
               
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
        playerViewModel?.embedInstructionsViewController(in: containerViewController, with: {})
    }
    
    // Called by the framework.
    // Remove the game view to pass back view control to the Peers App.
    func terminate(completionHandler: @escaping () -> Void) {
        os_log("[GAME DRAW] Terminate: removing game view.", type: .debug)
        playerViewModel?.removeResultController(from: containerViewController, with: completionHandler)
    }
    
    // Passes next image to draw
    func next(image: String) {
        playerViewModel?.nextImage(image)
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

private final class BundleToken {}
