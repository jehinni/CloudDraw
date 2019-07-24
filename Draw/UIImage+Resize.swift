//
//  UIImage+Resize.swift
//  Draw
//
//  Created by Johanna Reiting on 22.07.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	func resizedImage(targetSize: CGSize) -> UIImage {
		let size = self.size
		
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		
		self.draw(in: rect, blendMode: .normal, alpha: 1.0)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	
	func cropToBounds(width: Double, height: Double) -> UIImage? {
		let cgImage = self.cgImage
		
		let xPosition = 0.0
		let yPosition = height / 2
		
		let rect = CGRect(x: xPosition, y: yPosition, width: width, height: height)
		
		let imageRef = cgImage?.cropping(to: rect)
		let croppedImage = UIImage(cgImage: imageRef!)
		
		return croppedImage
	}
}
