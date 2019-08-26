//
//  HostResultViewController.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import UIKit
import PeersUI
import UICircularProgressRing
import os.log

class HostResultViewController: UIViewController {
    
    let timeForResult = 5
    
    weak var hostGameDelegate: HostGameDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countdownView: UICircularProgressRing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCountdown(countdownView, for: Int(timeForResult), repeatingAfter3: false)
        initTableView()
    }
    
    // Start a countdown for the specified time in seconds
    func startCountdown(_ countdown: UICircularProgressRing, for seconds: Int, repeatingAfter3: Bool) {
        DispatchQueue.main.async {
            countdown.animationTimingFunction = .linear
            if repeatingAfter3 {
                countdown.layer.isHidden = false
                countdown.startProgress(to: 0, duration: TimeInterval(seconds - 3), completion: {
                    countdown.layer.isHidden = true
                    countdown.startProgress(to: CGFloat(seconds), duration: 3)
                })
            } else {
                countdown.startProgress(to: 0, duration: TimeInterval(seconds))
            }
        }
    }

}

extension HostResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // Number of TableViewCells = number of players
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rankedPlayers = hostGameDelegate?.rankedPlayers else {
            os_log("[GAME DRAW] rankedPlayers are undefined in HostResultViewController", type: .error)
            return 0
        }
        return rankedPlayers.count
    }
    
    // Each TableViewCell presents a player's ranking position, name and points in the game.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get player's data (name, points, ranking position)
        let rankedPlayers: [RankingPositionMessage] = hostGameDelegate!.rankedPlayers
        let player = rankedPlayers[indexPath.row]
        let name = player.gamePlayer.player.peer.name
        let points = player.gamePlayer.result!
        let rankingPosition = player.rankingPosition
        // Set those data in the TableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostResultCell", for: indexPath)
            as! HostResultCell
        cell.positionLabel.text = "\(rankingPosition)."
        cell.nameLabel.text = name
        cell.pointsLabel.text = "\(points)/4"
        return cell
    }
}

