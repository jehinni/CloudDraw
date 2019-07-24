//
//  PeersHeadline1Label.swift
//  uielements-pod
//
//  Created by Manuela Müller on 29.05.19.
//

import UIKit

@IBDesignable
open class PeersHeadline1Label: PeersBaseLabel {
    
    private var headlineType = 0
    
    /// Sets the label type to h1
    public override func setupUI() {
        self.type = headlineType
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        //UIFont.loadPeerFonts
        self.type = headlineType
    }
}
