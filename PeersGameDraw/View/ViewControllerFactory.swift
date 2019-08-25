//
//  ViewControllerFactory.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 26.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerFactory {
    
    class func createHostInstructionsViewController() -> HostInstructionsViewController {
        let storyboard = UIStoryboard(name: "GameDrawHost", bundle: Bundle(for: BundleToken.self))
        return storyboard.instantiateViewController(withIdentifier: "HostInstructionsViewController") as! HostInstructionsViewController
    }
    
    class func createHostDrawViewController() -> HostDrawViewController {
         let storyboard = UIStoryboard(name: "GameDrawHost", bundle: Bundle(for: BundleToken.self))
        return storyboard.instantiateViewController(withIdentifier: "HostDrawViewController") as! HostDrawViewController
    }
    
    class func createHostResultViewController() -> HostResultViewController {
        let storyboard = UIStoryboard(name: "GameDrawHost", bundle: Bundle(for: BundleToken.self))
        return storyboard.instantiateViewController(withIdentifier: "HostResultViewController") as! HostResultViewController
    }
    
    class func createPlayerInstructionsViewController() -> PlayerInstructionsViewController {
        let storyboard = UIStoryboard(name: "GameDrawPlayer", bundle: Bundle(for: BundleToken.self))
        return storyboard.instantiateViewController(withIdentifier: "PlayerInstructionsViewController") as! PlayerInstructionsViewController
    }
    
    class func createPlayerDrawViewController() -> PlayerDrawViewController {
        let storyboard = UIStoryboard(name: "GameDrawPlayer", bundle: Bundle(for: BundleToken.self))
        return storyboard.instantiateViewController(withIdentifier: "PlayerDrawViewController") as! PlayerDrawViewController
    }
    
    class func createPlayerResultViewController() -> PlayerResultViewController {
        let storyboard = UIStoryboard(name: "GameDrawPlayer", bundle: Bundle(for: BundleToken.self))
        return storyboard.instantiateViewController(withIdentifier: "PlayerResultViewController") as! PlayerResultViewController
    }
    
}

private final class BundleToken {}
