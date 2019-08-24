//
//  PlayerDrawViewController.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import UIKit
import PeersUI

class PlayerDrawViewController: UIViewController, PlayerDrawViewModelDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var iSeeLabel: PeersHeadline4Label!
    @IBOutlet weak var predictionLabel: PeersHeadline2Label!
    @IBOutlet weak var drawingLabel: PeersHeadline4Label!
    @IBOutlet weak var mainImageView: UIImageView!
    var drawViewModel: PlayerDrawViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.backgroundColor = PeersColors.intensePurple.color
        iSeeLabel.isHidden = true
        predictionLabel.isHidden = true
        // TODO: inject viewModel
        drawViewModel = ViewModelFactory.createPlayerDrawViewModel(with: mainImageView)
        drawViewModel?.drawViewModelDelegate = self
        //        drawViewModel?.next(image: ) TODO: call in viewModel init?
    }
    
    // UIResponder methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstPoint = touches.first else { return }
        
        drawViewModel?.lastPoint = firstPoint.location(in: mainImageView)
        iSeeLabel.isHidden = true
        predictionLabel.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let firstPoint = touches.first else { return }
        
        drawViewModel?.userSwiped(to: firstPoint.location(in: mainImageView))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        drawViewModel?.draw()
        drawViewModel?.touchesEnded()
    }
    
    // IBAction methods
    
    @IBAction func deleteAll(_ sender: UIButton) {
        drawViewModel?.deleteAll()
        predictionLabel.isHidden = true
        iSeeLabel.isHidden = true
    }
    
    @IBAction func undo(_ sender: Any) {
        drawViewModel?.undo()
        predictionLabel.isHidden = true
        iSeeLabel.isHidden = true
    }
    
    @IBAction func finish(_ sender: Any) {
        drawViewModel?.finsih()
    }
    
    // PlayerDrawViewModelDelegate methods
    
    func didReceive(prediction: String) {
        predictionLabel.text = prediction
        predictionLabel.isHidden = false
        iSeeLabel.isHidden = false
    }
    
    func didReceiveRandomImage(imageName: String) {
        drawingLabel.text = "Please draw: " + imageName
    }
}

