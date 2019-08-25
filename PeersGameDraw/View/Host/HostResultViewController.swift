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
    
    weak var hostGameDelegate: HostGameDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countdownView: UICircularProgressRing!
}

extension HostResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // Number of TableViewCells = number of players
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rankedPlayers = hostGameDelegate?.rankedPlayers else {
            os_log("[GAME QUIZ] rankedPlayers are undefined in HostResultVC", type: .error)
            return 0
        }
        return rankedPlayers.count
    }
    
    // Each TableViewCell presents a player's ranking position, name and points in the game.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get player's data (name, points, ranking position)
        let rankedPlayers: [RankingPositionMessage] = hostGameDelegate!.rankedPlayers
        let i = indexPath.row
        let player = rankedPlayers[i]
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

