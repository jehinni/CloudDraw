//
//  CGPath+CreateFromPointArray.swift
//  Draw
//
//  Created by Johanna Reiting on 22.07.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

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
