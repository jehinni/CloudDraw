//
//  PeersText4Label.swift
//  PeersUI
//
//  Created by Manuela Müller on 30.06.19.
//

import UIKit

@IBDesignable
public class PeersText4Label: PeersBaseLabel {
    
    private var textType = 7
    
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
