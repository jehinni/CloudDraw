//
//  PeersAvailableHostCell.swift
//  PeersUI
//
//  Created by Johanna Reiting on 23.06.19.
//

import Foundation
import UIKit

open class PeersAvailableHostCell: UITableViewCell {
	@IBOutlet weak open var nameLabel: UILabel!
    @IBOutlet weak open var cellContainer: UIView!
    
	override open func awakeFromNib() {
		super.awakeFromNib()
	}
	
	open func setupUI(with name: String) {
		nameLabel.text = name
		nameLabel.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 20)
		nameLabel.tintColor = PeersColors.darkBlue.color
        
        self.selectionStyle = .none
        self.cellContainer.layer.cornerRadius = 6
        self.backgroundColor = UIColor.clear        
	}
}
