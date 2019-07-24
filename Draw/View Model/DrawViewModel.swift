//
//  DrawViewModel.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

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
		
		// load paths to be redrawn
		let path = CGPath.create(from: pointStorage.touchPoints)
		context.addPath(path)
		
		// visual appearance of lines
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
	
	func subject() -> String {
		// TODO: chose random subject
		return "Draw a \n Cat"
	}
	
	func finsih() {
		drawFinalImage()
		
		let finalImage = drawView.image
		let screenWidth = UIScreen.main.bounds.width
		let croppedImage = finalImage?.cropToBounds(width: Double(screenWidth), height: Double(screenWidth))
		let resizedImage = croppedImage?.resizedImage(targetSize: CGSize(width: 28, height: 28))
		let grayscaleBitmap = resizedImage!.bitMap2DimensionalArray()
		print(grayscaleBitmap)
	}
	
	func drawFinalImage() {
		UIGraphicsBeginImageContext(drawView.frame.size)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		
		drawView.image = nil
		drawView.image?.draw(in: drawView.bounds)
		
		// load paths to be redrawn
		let path = CGPath.create(from: pointStorage.touchPoints)
		context.addPath(path)
		
		// visual appearance of lines
		context.setBlendMode(.normal)
		context.setLineWidth(2)
		context.setLineJoin(.bevel)
		context.setStrokeColor(UIColor.black.cgColor)
		
		context.strokePath()
		
		drawView.image = UIGraphicsGetImageFromCurrentImageContext()
		drawView.alpha = 1
		UIGraphicsEndImageContext()
	}
}
