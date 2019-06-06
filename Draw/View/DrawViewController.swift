//
//  DrawViewController.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

	@IBOutlet weak var mainImageView: UIImageView!
	var drawViewModel: DrawViewModelProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		drawViewModel = ViewModelFactory.createDrawViewModel(with: mainImageView)
	}
	
	// MARK - UIResponder methods
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let firstPoint = touches.first else { return }
		
		drawViewModel?.lastPoint = firstPoint.location(in: view)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let firstPoint = touches.first else { return }
		
		drawViewModel?.userSwiped(to: firstPoint.location(in: view))
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
	
}

