//
//  PeersHeadline3Label.swift
//  uielements-pod
//
//  Created by Manuela Müller on 29.05.19.
//

import UIKit

@IBDesignable
public class PeersHeadline3Label: PeersBaseLabel {
    
    private var headlineType = 2
    
    /// Sets the label type to h3
    public override func setupUI() {
        self.type = headlineType
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        //UIFont.loadPeerFonts
        self.type = headlineType
    }
}
