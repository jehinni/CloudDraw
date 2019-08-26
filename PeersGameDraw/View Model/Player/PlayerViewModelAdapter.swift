//
//  PlayerViewModelAdapter.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

protocol PlayerViewModelAdapter {
    var randomImage: String? { get set }
    
    func nextImage(_ image: String)
    func embedInstructionsViewController(in viewController: UIViewController, with completionHandler: @escaping () -> Void)
    func embedDrawViewController(in viewController: UIViewController, with completionHandler:  @escaping () -> Void)
    func embedResultViewController(in viewController: UIViewController, with completionHandler: @escaping () -> Void)
    func removeResultController(from viewController: UIViewController, with completionHandler: @escaping () -> Void)
}
