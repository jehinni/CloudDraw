//
//  PlayerDrawViewModelProtocol.swift
//  Draw
//
//  Created by Johanna Reiting on 08.05.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

protocol PlayerDrawViewModelProtocol {
	var lastPoint: CGPoint { get set }
	var currentPoint: CGPoint { get }
	var swiped: Bool { get }
	var pointStorage: PointStorage { get }
	var cloudManager: CloudManager { get }
	var drawViewModelDelegate: PlayerDrawViewModelDelegate? { get set}
    
    var playerInstructionsViewController: PlayerInstructionsViewController { get }
    var playerDrawViewController: PlayerDrawViewController { get }
    var playerResultViewController: PlayerResultViewController { get }
    
    var playerGameDelegate: PlayerGameDelegate? { get set }
	
	func draw()
	func userSwiped(to point: CGPoint)
	func deleteAll()
	func undo()
	func touchesEnded()
	func finsih()
    func next(image: String)
    func next()
    
    
    func embedInstructionsViewController(in viewController: UIViewController, with completionHandler: @escaping () -> Void)
    func embedDrawViewController(in viewController: UIViewController, with completionHandler:  @escaping () -> Void)
    func embedResultViewController(in viewController: UIViewController, with completionHandler: @escaping () -> Void)
    func removeResultController(from viewController: UIViewController, with completionHandler: @escaping () -> Void)
}
