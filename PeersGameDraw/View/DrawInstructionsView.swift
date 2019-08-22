//
//  DrawInstructionsView.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import UIKit
import PeersUI
import UICircularProgressRing

class DrawInstructionsView: UIView {

    @IBOutlet var instructionsView: UIView!
    @IBOutlet weak var headlineLabel: PeersHeadline1Label!
    
    @IBOutlet weak var instructionsLabel: PeersText1Label!
    @IBOutlet weak var progressView: UICircularProgressRing!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
