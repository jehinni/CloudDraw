//
//  PeersImageView.swift
//  uielements-pod
//
//  Created by Manuela Müller on 09.06.19.
//

import UIKit

@IBDesignable open class PeersImageView: UIImageView {
    
    @IBInspectable var chosenImage: Int = 0 {
        didSet {
            setImage()
        }
    }
    
    open override func layoutSubviews() {
        setImage()
    }
    
    private func setImage() {
        
        if (chosenImage <= PeersImages.allImages.count) {
            self.image = PeersImages.allImages[chosenImage].image
        } else {
            self.image = PeersImages.allImages[0].image
        }
        
    }

    
}
