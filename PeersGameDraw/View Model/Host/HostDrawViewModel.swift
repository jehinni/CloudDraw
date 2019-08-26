//
//  HostDrawViewModel.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import os.log
import UIKit
import UICircularProgressRing

class HostDrawViewModel: HostDrawViewModelProtocol {
    
    var hostGameDelegate: HostGameDelegate?
    
    var image: String?
    weak var drawViewModelDelegate: HostDrawViewModelDelegate?
    
    // Next image to draw received.
    // Update ViewController and start countdown.
    func next(image: String, countdown: UICircularProgressRing) {
        self.image = image
        os_log("viewModel image: %@", type: .debug, image)
        drawViewModelDelegate?.didUpdate(image: image)
        
        startCountdown(countdown, for: 10, repeatingAfter3: true)
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
