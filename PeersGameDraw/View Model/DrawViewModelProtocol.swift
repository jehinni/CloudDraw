//
//  DrawViewModelProtocol.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

protocol DrawViewModelProtocol {
	var lastPoint: CGPoint { get set }
	var currentPoint: CGPoint { get }
	var swiped: Bool { get }
	var pointStorage: PointStorage { get }
	var cloudManager: CloudManager { get }
	var drawViewModelDelegate: DrawViewModelDelegate? { get set}
	
	func draw()
	func userSwiped(to point: CGPoint)
	func deleteAll()
	func undo()
	func touchesEnded()
	func finsih()
    func randomImage()
}
