//
//  GameDrawHostGameImpl.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework
import os.log

class GameDrawHostGameImpl: HostGame {
    
    let timeForInstructions = 10
    let numberOfImages = 4
    let timeForResult = 5
    
    var framework: HostFramework?
    
    var gamePlayers: [GamePlayer] = []
    var players: [Player] { return self.gamePlayers.map({ $0.player }) }
    var rankedPlayers: [RankingPositionMessage] = []
    var allPlayerResultsSet: Bool { return self.gamePlayers.filter({ $0.result == nil }).count == 0 }
    
    var ignoreAnyMessages: Bool = false
    
    var images: [String]?
    
    var instructionsTimer: Timer?
    var drawTimer: Timer?
    var timeoutEndGame: Timer?
    
    unowned var containerViewController: UIViewController
    var hostInstructionsViewController: HostInstructionsViewController
    var hostDrawViewController: HostDrawViewController
    var hostResultViewController: HostResultViewController
    // TODO: remove viewController references
    var hostViewModel: HostViewModelAdapter?
    
    init(parentViewController: UIViewController) {
        containerViewController = parentViewController
        
         let storyboard = UIStoryboard(name: "GameDrawHost", bundle: Bundle(for: BundleToken.self))
        hostInstructionsViewController = storyboard.instantiateViewController(withIdentifier: "HostInstructionsViewController") as! HostInstructionsViewController
        hostDrawViewController = storyboard.instantiateViewController(withIdentifier: "HostDrawViewController") as! HostDrawViewController
        hostResultViewController = storyboard.instantiateViewController(withIdentifier: "HostResultViewController") as! HostResultViewController
        
        // TODO: inject
        hostViewModel = ViewModelFactory.createHostViewModel()
    }
    
    deinit {
        os_log("[GAME DRAW] host deinit", type: .debug)
    }
    
    // HostGame methods
    
    // Handles messages received from players.
    func handle(message: Data, ofType: String, from peer: Peer) {
        guard !ignoreAnyMessages else {
            os_log("[GAME DRAW] Explicitly ignoring messages from any peers", type: .info)
            return
        }
        do {
            os_log("[GAME DRAW] Received message %s.", type: .debug, ofType)
            switch ofType {
            // TODO: this message is not needed?
            case "\(ImagePredictionMessage.self)":
                let data = try MessageWrapper.decodeData(type: ImagePredictionMessage.self, data: message)
                setCurrentPlayerPrediction(data.prediction, for: peer)
            case "\(PointsMessage.self)":
                let data = try MessageWrapper.decodeData(type: ResultMessage.self, data: message)
                setCurrentPlayerPoints(data.points, for: peer)
            case "\(ResultMessage.self)":
                let data = try MessageWrapper.decodeData(type: ResultMessage.self, data: message)
                setPlayerResult(points: data.points, for: peer)
            default:
                os_log("[GAME DRAW] Received unknown message.", type: .error)
            }
        } catch {
            os_log("[GAME DRAW ] Failed to decode message of type %s: %@", type: .error, ofType, error.localizedDescription)
        }
    }
    
    // Called by the Framework.
    func prepare(players: [Player]) {
        setGamePlayers(players)
        images = ImageGenerator.generateRandomImages(numberOfImages)
    }
    
    // Called by the Framework.
    // Showing instruction views for the specified time.
    // Then switching views and starting the drawing timer.
    func play() {
        os_log("[GAME DRAW] Play: switching to instructions view and starting questions timer.", type: .debug)
        switchViewController(old: nil, new: self.hostInstructionsViewController, messageToPlayers: nil)
        DispatchQueue.main.async {
            self.instructionsTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.timeForInstructions), repeats: false, block: { [weak self] timer in
                guard let this = self else {
                    os_log("[GAME DRAW] self is undefined in scheduled timer in startCountdown().", type: .error)
                    return
                }
                os_log("[GAME DRAW] Play: triggering game start i.e. switching views and starting question timer.", type: .debug)
                this.switchViewController(old: this.hostInstructionsViewController, new: this.hostDrawViewController, messageToPlayers: "GameStartMessage")
                this.startDrawingTimer()
            })
        }
    }
    
    // Called by the Framework. Returns the ranked players (winner to looser)
    // after showing the result view.
    func evaluate() -> [GamePlayer] {
        os_log("[GAME DRAW] Evaluate: removing game view and returning ranked players.", type: .debug)
        switchViewController(old: hostDrawViewController, new: hostResultViewController, messageToPlayers: "GameEndMessage")
        sleep(UInt32(Int(timeForResult)))
        switchViewController(old: hostResultViewController, new: nil, messageToPlayers: nil)
        return gamePlayers
    }
    
    // Forces the game to stop, even mid-lifecycle.
    func terminate(completionHandler: @escaping () -> Void) {
        os_log("[GAME DRAW] Terminating now...", type: .info)
        ignoreAnyMessages = true
        drawTimer?.invalidate()
        timeoutEndGame?.invalidate()
        completionHandler()
    }
    
    // Sets the GamePlayers. These are the players with additional info (current & final points).
    private func setGamePlayers(_ players: [Player]) {
        os_log("[GAME DRAW] Setting the GamePlayers from players.", type: .debug)
        gamePlayers = players.map({ return GamePlayer(from: $0) })
    }
    
    // Set the prediction for the player, so it can be displayed after the timer has ended.
    private func setCurrentPlayerPrediction(_ prediction: String, for peer: Peer) {
        guard let gamePlayerIndex: Int = gamePlayers.firstIndex(where: { $0.player.peer == peer }) else {
            os_log("[GAME DRAW] GamePlayer could not be found in playersWithResult in setCurrentPlayerPrediction.", type: .error)
            return
        }
        os_log("[GAME DRAW] Setting prediction to %d for game player with index %d.", type: .debug, prediction, gamePlayerIndex)
    }
    
    // Sets the current points for the player, so these can be displayed.
    private func setCurrentPlayerPoints(_ points: Int, for peer: Peer) {
        // TODO: instead of points send if prediction was correct???
        guard let gamePlayer: GamePlayer = gamePlayers.first(where: { $0.player.peer == peer }) else {
            os_log("[GAME DRAW] GamePlayer could not be found in playersWithResult in setCurrentPlayerPoints.", type: .error)
            return
        }
        os_log("[GAME DRAW] Setting %d current points for game player \"%@\".", type: .debug, points, gamePlayer.player.peer.name)
        gamePlayer.points = points
    }
    
    // Start a timer for the user which sends a new image to draw every x seconds.
    private func startDrawingTimer() {
        os_log("[GAME DRAW] Starting drawing timer.", type: .debug)
 
        var currentRound = -1
        DispatchQueue.main.async {
            let timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.timeForResult), repeats: true, block: { [weak self] timer in
 
                currentRound += 1
                if currentRound == self?.numberOfImages {
                    self?.endGame(timer: timer)
                    return
                }
                os_log("[GAME DRAW] Showing next question and sending it to players (question %d/%d)", type: .debug, (currentRound + 1), self!.numberOfImages)
                let image: String = self!.images![currentRound]
                self?.hostViewModel?.nextImage(image)
                self?.framework?.sendGameDataToPlayers(message: NextImageMessage(randomImage: image), to: self?.players, sendMode: .reliable)
            })
            
            timer.fire() // fire timer for 1st question immediately
            self.drawTimer = timer
        }
    }
    
    // Handle a player exiting during the game.
    func lostPlayer(_ player: Player) {
        os_log("[GAME DRAW] Lost player: removing player %@ from GamePlayers.", type: .debug, player)
        gamePlayers.removeAll(where: { $0.player.peer == player.peer })
    }
    
    // Ends game: Stops timer and asks the players to send their result (final points).
    private func endGame(timer: Timer) {
        os_log("[GAME DRAW] Ending game: asking players to send their result.", type: .debug)
        timer.invalidate()
        self.framework?.sendGameDataToPlayers(message: ResultRequestMessage(), to: self.players, sendMode: .reliable)
        // Timeout to finish game even if a player gets lots
        self.timeoutEndGame = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { [weak self] timer in
            guard let this = self else {
                os_log("[GAME DRAW] self is undefined in scheduled timer in endGame().", type: .error)
                return
            }
            if this.allPlayerResultsSet {
                this.calculateRankingAndBackToApp()
            }
        })
    }
    
    // Sets the player's game result (final points) and calls backToApp() if all player results have been set.
    private func setPlayerResult(points: Int, for peer: Peer) {
        guard let gamePlayer: GamePlayer = gamePlayers.first(where: { $0.player.peer == peer }) else {
            os_log("[GAME DRAW] GamePlayer could not be found in playersWithResult.", type: .error)
            return
        }
        os_log("[GAME DRAW] Setting %d points as result for game player \"%@\".", type: .debug, points, gamePlayer.player.peer.name)
        gamePlayer.result = points
        if allPlayerResultsSet {
            timeoutEndGame?.invalidate()
            calculateRankingAndBackToApp()
        }
    }
    
    // After the game has been finished, sends results (ranking position) to players.
    private func calculateRankingAndBackToApp() {
        os_log("[GAME DRAW] All player results set: calculating ranking & sending players their result.", type: .debug)
        let rankedPlayers = Dictionary(grouping: self.gamePlayers, by: { $0.result! }).sorted(by: { $0.key > $1.key })
        // Send each player their result (= position in the ranking)
        var rankingPosition = 1
        for (_, gamePlayers) in rankedPlayers {
            for gamePlayer in gamePlayers {
                let player: Player = gamePlayer.player
                let rankingPositionMessage = RankingPositionMessage(gamePlayer, rankingPosition)
                self.rankedPlayers.append(rankingPositionMessage)
                self.framework?.sendGameDataToPlayers(message: rankingPositionMessage, to: [player], sendMode: .reliable)
            }
            rankingPosition += 1
        }
        self.endGame()
    }
    
    // Ends the game and passes control back to the app.
    private func endGame() {
        os_log("[GAME DRAW] Ending game -> back to app.", type: .debug)
        self.framework?.finishGame()
    }
    
}

// TODO: own file
extension GameDrawHostGameImpl {
    // Switches the view (app > instructions > game > result > app).
    func switchViewController(old: UIViewController?, new: UIViewController?, messageToPlayers: String?) {
        os_log("[GAME DRAW] Switching views: %s -> %s", type: .debug, String(describing: old.self), String(describing: new.self))
        
        DispatchQueue.main.async {
            
            if (old != nil) {
                // remove old view
                old!.view.removeFromSuperview()
                old!.removeFromParent()
            }
            
            if (new != nil) {
                // add new view
                self.containerViewController.addChild(new!.self)
                self.containerViewController.view.addSubview(new!.view)
                
                // add constraints
                new!.view.translatesAutoresizingMaskIntoConstraints = false
                new!.view.topAnchor.constraint(equalTo: self.containerViewController.view.topAnchor).isActive = true
                new!.view.bottomAnchor.constraint(equalTo: self.containerViewController.view.bottomAnchor).isActive = true
                new!.view.leadingAnchor.constraint(equalTo: self.containerViewController.view.leadingAnchor).isActive = true
                new!.view.trailingAnchor.constraint(equalTo: self.containerViewController.view.trailingAnchor).isActive = true
            }
            
            // send view change message to players
            if (messageToPlayers != nil) {
                switch messageToPlayers! {
                case "GameStartMessage":
                    self.framework?.sendGameDataToPlayers(message: GameStartMessage(), to: self.players, sendMode: .reliable)
                case "GameEndMessage":
                    self.framework?.sendGameDataToPlayers(message: GameEndMessage(), to: self.players, sendMode: .reliable)
                default:
                    os_log("[GAME DRAW] Unknown message type in switchView(): %s", type: .debug, messageToPlayers!)
                }
            }
            
        }
        
    }
}

private final class BundleToken {}
