//
//  CloudManagerDelegate.swift
//  Draw
//
//  Created by Johanna Reiting on 24.07.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

protocol CloudManagerDelegate: AnyObject {
	func didReceive(prediction: [String : AnyObject])
}
