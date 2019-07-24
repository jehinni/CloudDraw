//
//  PeersNavigationLabel.swift
//  uielements-pod
//
//  Created by Manuela Müller on 29.05.19.
//

import UIKit

@IBDesignable
public class PeersNavigationLabel: PeersBaseLabel {
    
    private var textType = 8
    
    /// Sets the label type to "navigation"
    public override func setupUI() {
        self.type = textType
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        //UIFont.loadPeerFonts
        self.type = textType
    }
}
