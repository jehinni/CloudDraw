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
    
    var drawViewModel: HostDrawViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: inject
        drawViewModel? = ViewModelFactory.createHostDrawViewModel()
        drawViewModel?.drawViewModelDelegate = self
    }
    
    func didUpdate(image: String) {
        imageLabel.text = image
        os_log("controller image: %@, controller label text: %@", type: .debug, image, imageLabel.text ?? "no text")
    }
    
}
