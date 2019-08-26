//
//  HostDrawViewController.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import UIKit
import PeersUI
import UICircularProgressRing
import os.log

class HostDrawViewController: UIViewController, HostDrawViewModelDelegate {
    

    @IBOutlet weak var countdownView: UICircularProgressRing!
    @IBOutlet weak var imageLabel: PeersHeadline4Label!
    
    var hostDrawViewModel: HostDrawViewModelProtocol? {
        didSet {
            hostDrawViewModel?.drawViewModelDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func next(image: String) {
        hostDrawViewModel?.next(image: image)
        startCountdown(countdownView, for: 10, repeatingAfter3: true)
    }
    
    func didUpdate(image: String) {
        imageLabel.text = image
        os_log("controller image: %@, controller label text: %@", type: .debug, image, imageLabel.text ?? "no text")
    }
    
}

extension HostDrawViewController {
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
