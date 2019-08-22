//
//  PlayerDrawViewModelDelegate.swift
//  Draw
//
//  Created by Johanna Reiting on 24.07.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

protocol PlayerDrawViewModelDelegate: AnyObject {
	func didReceive(prediction: String)
    func randomImage(imageName: String)
}
