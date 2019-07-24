//
//  PeersNavigationController.swift
//  uielements-pod
//
//  Created by Manuela Müller on 29.05.19.
//

import UIKit

@IBDesignable
open class PeersNavigationController: UINavigationController {
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupAppearance()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()

        self.delegate = self
    }

    /// Customizes the UINavigationController (colours, title color and font)
    private func setupAppearance() {
        
        let titleColor = PeersColors.neonBlue.color
        let titleFont: UIFont = PeersFonts.RockSalt.regular.font(size: 16)
        
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: titleFont,
            
        ]

        self.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        self.navigationBar.barTintColor = PeersColors.darkBlue.color
        self.navigationBar.tintColor = PeersColors.neonBlue.color
        self.navigationBar.isTranslucent = false
        
        /// Prompt
        
        
    }
}

extension PeersNavigationController: UINavigationControllerDelegate {

    /// Creates a navigation controller and customizes the back button style (colors, title color and font)
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        let navigationFont = PeersFonts.BarlowSemiCondensed.medium.font(size: 20)
        let titleColor = PeersColors.neonBlue.color
        
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: navigationFont
        ]
    
        viewController.navigationItem.backBarButtonItem?.setTitleTextAttributes(textAttributes as [NSAttributedString.Key : Any], for: UIControl.State.normal)
        
    }
}
