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
        hostDrawViewModel?.next(image: image, countdown: countdownView)
    }
    
    // HostDrawViewModelDelegate method
    
    func didUpdate(image: String) {
        imageLabel.text = image
    }
    
}
