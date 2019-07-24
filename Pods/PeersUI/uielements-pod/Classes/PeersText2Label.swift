//
//  PeersText2Label.swift
//  uielements-pod
//
//  Created by Manuela Müller on 29.05.19.
//

import UIKit

@IBDesignable
public class PeersText2Label: PeersBaseLabel {
    
    private var textType = 5
    
    /// Sets the label type to text
    public override func setupUI() {
        self.type = textType
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        //UIFont.loadPeerFonts
        self.type = textType
    }
}
