//
//  PlayerResultViewController.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import UIKit
import PeersUI
import UICircularProgressRing

class PlayerResultViewController: UIViewController {

    @IBOutlet weak var countdownView: UICircularProgressRing!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var resultLabel: PeersText1Label!
    
    weak var playerGameDelegate: PlayerGameDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startCountdown(countdownView, for: 10, repeatingAfter3: false)
        if playerGameDelegate?.finalRankingPosition == 1 {
            setLabelTextsToWinner()
        }
    }
    
    // TODO: from ViewModel + emoji
    private func setLabelTextsToWinner() {
        emojiLabel.text = " // = award icon
        resultLabel.text = "Congratulations! You won this game, keep going!"
    }

}

 // TODO: from ViewModel
extension PlayerResultViewController {
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
