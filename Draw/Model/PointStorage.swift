//
//  PointStorage.swift
//  Draw
//
//  Created by Johanna Reiting on 06.06.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

class PointStorage {
	var touchPoints: [CGPoint]
	
	init(with points: [CGPoint]) {
		touchPoints = points
	}
	
	func add(point: CGPoint) {
		touchPoints.append(point)
	}
}
