//
//  PeersText3Label.swift
//  uielements-pod
//
//  Created by Manuela Müller on 29.05.19.
//

import UIKit

@IBDesignable
public class PeersText3Label: PeersBaseLabel {
    
    private var textType = 6
    
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
