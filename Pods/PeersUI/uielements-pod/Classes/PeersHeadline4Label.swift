//
//  PeersHeadline4Label.swift
//  uielements-pod
//
//  Created by Manuela Müller on 29.05.19.
//

import UIKit

@IBDesignable
public class PeersHeadline4Label: PeersBaseLabel {
    
    private var headlineType = 3
    
    /// Sets the label type to h4
    public override func setupUI() {
        self.type = headlineType
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        //UIFont.loadPeerFonts
        self.type = headlineType
    }
}
