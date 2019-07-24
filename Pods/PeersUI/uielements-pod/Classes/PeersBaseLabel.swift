//
//  PeersText.swift
//  uielements-pod
//
//  Created by Manuela Müller on 27.05.19.


#if os(OSX)
    import AppKit.NSColor
    public typealias LabelColor = NSColor
#elseif os(iOS) || os(tvOS)
    import UIKit.UIColor
    public typealias LabelColor = UIColor
#endif

/// The different label types
@objc enum PeersLabelType: Int, CaseIterable {
    case h1 = 0
    case h2 = 1
    case h3 = 2
    case h4 = 3
    case text1 = 4
    case text2 = 5
    case text3 = 6
    case text4 = 7
    case navigation = 8

}

/// Extension for label type attributes
extension PeersLabelType {
    
    var color: LabelColor {
        switch self {
        case .h1, .h2, .h3, .text2, .navigation:
            return PeersColors.neonBlue.color
        case .h4:
            return PeersColors.lightPink.color
        case .text1:
            return UIColor.white
        case .text3:
            return PeersColors.darkBlue.color
        case .text4:
            return PeersColors.darkGrey.color
        }
    }
    
    var font: UIFont {
        switch self {
        case .h1:
            return PeersFonts.RockSalt.regular.font(size: 26)
        case .h2:
            return PeersFonts.RockSalt.regular.font(size: 20)
        case .h3:
            return PeersFonts.RockSalt.regular.font(size: 16)
        case .h4:
            return PeersFonts.BarlowSemiCondensed.bold.font(size: 20)
        case .text1, .text3:
            return PeersFonts.BarlowSemiCondensed.medium.font(size: 18)
        case .text2:
            return PeersFonts.BarlowSemiCondensed.bold.font(size: 18)
        case .text4:
            return PeersFonts.BarlowSemiCondensed.light.font(size: 18)
        case .navigation:
            return PeersFonts.BarlowSemiCondensed.medium.font(size: 20)
        }
    }
}

/// The base class for all label types
@IBDesignable open class PeersBaseLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    public var type: Int = 4 {
        didSet {
            if type < PeersLabelType.allCases.count {
                labelType = PeersLabelType(rawValue: type)!
            } else {
                labelType = PeersLabelType(rawValue: 0)!
            }
        }
    }

    var labelType: PeersLabelType = .text1 {
        didSet {
            self.textColor = self.labelType.color
            self.font = self.labelType.font
        }
    }
    
    public func setupUI() {
        // override in subclasses
    }
    
    
}
