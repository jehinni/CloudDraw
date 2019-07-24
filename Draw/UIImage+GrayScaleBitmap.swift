//
//  UIImage+GrayScaleBitmap.swift
//  Draw
//
//  Created by Johanna Reiting on 22.07.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	func grayScalePixels() -> [UInt8]? {
		guard let cgImage = self.cgImage else { return nil }
		
		let bitsPerComponent = 8
		let width = cgImage.width
		let height = cgImage.height
		let totalBytes = width * height
		let colorSpace = CGColorSpaceCreateDeviceGray()
		var byteArray: [UInt8] = Array(repeating: UInt8.max, count: totalBytes)
		let success = byteArray.withUnsafeMutableBufferPointer { (buffer) -> Bool in
			guard let imageContext = CGContext(data: buffer.baseAddress!, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: width, space: colorSpace, bitmapInfo: 0) else { return false }
			imageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
			return true;
		}
		return success ? byteArray : nil
	}
	
	func bitMap2DimensionalArray() -> [[UInt8]]? {
		guard let cgImage = self.cgImage else { return nil }
		guard let pixels = self.grayScalePixels() else { return nil }
		
		let width = cgImage.width
		let height = cgImage.height
		var result: [[UInt8]] = []
		
		for y in 0..<height {
			var widthPixels = [UInt8]()
			for x in 0..<width {
				let index = width * y + x
				var pixel = pixels[index]
				if pixel != 255 {
					pixel = 0
				}
				widthPixels.append(pixel)
			}
			result.append(widthPixels)
		}
		
		return result
	}
	
}
