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
	var touchPoints: [[CGPoint]]
	
	init() {
		touchPoints = []
	}
	
	func add(points: [CGPoint]) {
		touchPoints.append(points)
	}
	
	func removeLast() {
		touchPoints.removeLast()
	}
}
