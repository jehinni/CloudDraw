//
//  ViewModelFactory.swift
//  Draw
//
//  Created by Johanna Reiting on 06.06.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

class ViewModelFactory {
	class func createPlayerDrawViewModel(with imageView: UIImageView) -> PlayerDrawViewModel {
		return PlayerDrawViewModel(with: imageView)
	}
}
