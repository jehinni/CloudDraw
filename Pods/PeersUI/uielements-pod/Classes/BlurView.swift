//
//  BlurView.swift
//  uielements-pod
//
//  Created by Manuela Müller on 05.06.19.

import UIKit

@IBDesignable open class BlurView: UIImageView {
    
    open override func layoutSubviews() {
        setupUI()
    }
    
    private func setupUI() {
        
        image = PeersImages.background.image
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.4
        self.addSubview(blurView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: 0).isActive = true
        
    }
    
}
