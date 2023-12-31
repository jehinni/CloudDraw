//
//  PlayerDrawViewModel.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import os.log

class PlayerDrawViewModel: PlayerDrawViewModelProtocol, CloudManagerDelegate {
    
    var drawView: UIImageView
    var pointStorage: PointStorage
    var lastPoint: CGPoint
    var currentPoint: CGPoint
    var swiped: Bool
    var currentPoints: [CGPoint]
    var cloudManager: CloudManager
    var drawViewModelDelegate: PlayerDrawViewModelDelegate?
    var randomImage: String?
    
    var playerGameDelegate: PlayerGameDelegate?
    
    init(with imageView: UIImageView) {
        
        drawView = imageView
        pointStorage = PointStorage()
        lastPoint = CGPoint.zero
        currentPoint = CGPoint.zero
        swiped = false
        currentPoints = []
        cloudManager = CloudManager()
        cloudManager.cloudManagerDelegate = self
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
    
    func showSolutionOnCountdownEnd() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(10 - 3), repeats: false, block: { [weak self] timer in
            guard let this = self else {
                os_log("[GAME DRAW] self is undefined in scheduled timer in showSolutionOnCountdownEnd().", type: .error)
                return
            }
            this.finish()
        })
    }
    
    // Convert final image to size that model needs
    // Grab bitmap of final image and send bitmap to Cloud
    func finish() {
        drawFinalImage()
        
        let finalImage = drawView.image
        let resizedImage = finalImage?.resizedImage(targetSize: CGSize(width: 28, height: 28))
        
        guard let image = resizedImage else { return }
        let grayscaleBitmap = image.bitMap2DimensionalArray()
        
        guard let bitmap = grayscaleBitmap else { return }
        if randomImage == nil { return }
        cloudManager.send(label: randomImage!, bitmap: bitmap)
    }
    
    // Next image to draw has been received.
    // Update ViewController with new image subject.
    func next(image: String) {
        randomImage = image
        DispatchQueue.main.async {
            self.drawViewModelDelegate?.didReceiveRandomImage(imageName: self.randomImage ?? "No image received")
        }
    }
    
    // Re-draw every line to join to one picture
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
    
    // CloudManagerDelegate method
    
    func didReceive(prediction: [String : AnyObject]) {
        let predictedObject = prediction["prediction"] as! String
        
        DispatchQueue.main.async {
            self.playerGameDelegate?.didReceive(prediction: predictedObject)
            
            if predictedObject == self.randomImage {
                self.playerGameDelegate?.didUpdate(points: 1)
            }
            
            self.drawViewModelDelegate?.didReceive(prediction: predictedObject)
        }
        
    }
    
}
