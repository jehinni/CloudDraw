//
//  HostDrawViewModelProtocol.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

protocol HostDrawViewModelProtocol {
    
    var hostInstructionsViewController: HostInstructionsViewController { get }
    var hostDrawViewController: HostDrawViewController { get }
    var hostResultViewController: HostResultViewController { get }

    var drawViewModelDelegate: HostDrawViewModelDelegate? { get set }
    var image: String? { get set }
    
    
    
    func next(image: String)
    
    func embedInstructionsViewController(in viewController: UIViewController)
    func embedDrawViewController(in viewController: UIViewController)
    func embedResultViewController(in viewController: UIViewController)
    func removeResultController(from viewController: UIViewController)
    
    var hostGameDelegate: HostGameDelegate? { get set }
    
}
