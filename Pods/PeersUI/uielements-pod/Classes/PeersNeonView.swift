//
//  PeersNeonView.swift
//  
//
//  Created by Benjamin Kramser on 30.05.19.
//

import Foundation
import UIKit

@IBDesignable class PeersNeonView: UIView {
    
    @IBInspectable var neonLightColor: UIColor = PeersColors.neonBlue.color
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        
        let startColor: UIColor = neonLightColor.withAlphaComponent(0.5)
        let endColor: UIColor = UIColor.white.withAlphaComponent(0.0)
        
        (layer as! CAGradientLayer).colors = [startColor.cgColor, endColor.cgColor]
        self.backgroundColor = .clear
        
        let sourceView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 5))
        sourceView.backgroundColor = neonLightColor
        self.addSubview(sourceView)
        
        
    }
    
}
