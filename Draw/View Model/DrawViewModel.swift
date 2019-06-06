//
//  DrawViewModel.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

class DrawViewModel: DrawViewModelProtocol {
	var drawView: UIImageView
	var pointStorage: PointStorage
	var lastPoint: CGPoint
	var currentPoint: CGPoint
	var swiped: Bool
	var currentPoints: [CGPoint]
	
	init(with imageView: UIImageView) {
		drawView = imageView
		pointStorage = PointStorage()
		lastPoint = CGPoint.zero
		currentPoint = CGPoint.zero
		swiped = false
		currentPoints = []
	}
	
	func draw() {
		//pointStorage.add(point: lastPoint)
		currentPoints.append(lastPoint)
		
		UIGraphicsBeginImageContext(drawView.frame.size)
		guard let context = UIGraphicsGetCurrentContext() else {
			return
		}
		
		drawView.image?.draw(in: drawView.bounds)
		context.move(to: lastPoint)
		
		if swiped {
			context.addLine(to: currentPoint)
		} else {
			context.addLine(to: lastPoint)
		}
		
		// visual appearance of lines
		context.setBlendMode(.normal)
		context.setLineWidth(2)
		context.setStrokeColor(UIColor.black.cgColor)
		
		context.strokePath()
		
		drawView.image = UIGraphicsGetImageFromCurrentImageContext()
		drawView.alpha = 1
		UIGraphicsEndImageContext()
		
		lastPoint = currentPoint
	}
	
	func userSwiped(to point: CGPoint) {
		swiped = true
		currentPoint = point
		draw()
		swiped = false
	}
	
	func deleteAll() {
		pointStorage.touchPoints.removeAll()
		drawView.image = nil
	}
	
	func undo() {
		UIGraphicsBeginImageContext(drawView.frame.size)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		pointStorage.removeLast()
		
		drawView.image = nil
		drawView.image?.draw(in: drawView.bounds)
		
		let path = CGPath.create(from: pointStorage.touchPoints)
		context.addPath(path)
		context.setStrokeColor(UIColor.black.cgColor)
		context.strokePath()
		
		drawView.image = UIGraphicsGetImageFromCurrentImageContext()
		drawView.alpha = 1
		UIGraphicsEndImageContext()
	}
	
	func touchesEnded() {
		pointStorage.add(points: currentPoints)
		currentPoints = []
	}
	
}

extension CGPath {
	static func create(from points:[[CGPoint]]) -> CGPath {
		
		let flattened = Array(points.joined())
		
		let path = CGMutablePath()
		path.addLines(between: flattened)
		
		return path.copy(strokingWithWidth: 2, lineCap: .butt, lineJoin: .miter, miterLimit: 2)
	}
}
