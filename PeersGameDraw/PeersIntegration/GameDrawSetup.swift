//
//  GameDrawSetup.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 22.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import PeersFramework

public class GameDrawSetup: GamePartFactory {
    
    public init() {}
    
    public func createHostGame(containerViewController viewController: UIViewController) -> HostGame {
        return GameDrawHostGameImpl(parentViewController: viewController)
    }
    
    public func createPlayerGame(containerViewController viewController: UIViewController) -> PlayerGame {
        return GameDrawPlayerGameImpl(parentViewController: viewController)
    }
}
