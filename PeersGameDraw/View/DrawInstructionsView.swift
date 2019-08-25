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
    
    let timeForInstructions = 5

    @IBOutlet var instructionsView: UIView!
    @IBOutlet weak var headlineLabel: PeersHeadline1Label!
    
    @IBOutlet weak var instructionsLabel: PeersText1Label!
    @IBOutlet weak var progressView: UICircularProgressRing!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle(for: BundleToken.self).loadNibNamed("GameQuizInstructionsView", owner: self, options: nil)
        addSubview(self.instructionsView)
        self.instructionsView.frame = self.bounds
        self.showCountdown()
    }
    
    private func showCountdown() {
        DispatchQueue.main.async {
            self.progressView.animationTimingFunction = .linear
            self.progressView.startProgress(to: 0, duration: TimeInterval(timeForInstructions))
        }
    }


}
