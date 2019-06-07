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
		pointStorage.removeLast()
		
		UIGraphicsBeginImageContext(drawView.frame.size)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		drawView.image = nil
		drawView.image?.draw(in: drawView.bounds)
		
		let path = CGPath.create(from: pointStorage.touchPoints)
		context.addPath(path)
		context.setBlendMode(.normal)
		context.setLineWidth(2)
		context.setLineJoin(.bevel)
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
		
		let wholePath = CGMutablePath()
		
		for array in points {
			let path = CGMutablePath()
			path.addLines(between: array)
			wholePath.addPath(path)
		}
		
		return wholePath.copy(strokingWithWidth: 0.1, lineCap: .butt, lineJoin: .bevel, miterLimit: 1)
	}
}
