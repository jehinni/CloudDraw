//
//  DrawViewController.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import UIKit
import PeersUI

class DrawViewController: UIViewController {

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var subjectLabel: UILabel!
	@IBOutlet weak var mainImageView: UIImageView!
	var drawViewModel: DrawViewModelProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		backgroundImageView.backgroundColor = PeersColors.intensePurple.color
		drawViewModel = ViewModelFactory.createDrawViewModel(with: mainImageView)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		subjectLabel.text = drawViewModel?.subject()
		fadeOutView(view: subjectLabel)
	}
	
	// MARK - UIResponder methods
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let firstPoint = touches.first else { return }
		
		drawViewModel?.lastPoint = firstPoint.location(in: mainImageView)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let firstPoint = touches.first else { return }
		
		drawViewModel?.userSwiped(to: firstPoint.location(in: mainImageView))
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		drawViewModel?.draw()
		drawViewModel?.touchesEnded()
	}
	
	@IBAction func deleteAll(_ sender: UIButton) {
		drawViewModel?.deleteAll()
	}
	
	@IBAction func undo(_ sender: Any) {
		drawViewModel?.undo()
	}
	
	@IBAction func finish(_ sender: Any) {
		drawViewModel?.finsih()
	}
}

extension DrawViewController {
	func fadeOutView(view: UIView) {
		UIView.animate(withDuration: 3, delay: 0, options: .curveLinear, animations: { () -> Void in
			view.alpha = 0
			}, completion: nil)
	}
}

