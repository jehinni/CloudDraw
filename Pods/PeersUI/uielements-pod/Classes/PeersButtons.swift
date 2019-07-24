//
//  PeersButton.swift
//  Pods-uielements-pod_Example
//
//  Created by Manuela Müller on 22.05.19.

import Foundation
import UIKit

/// The different button styles
@objc enum PeersButtonStyle: Int, RawRepresentable, CaseIterable {
    case neonPinkBig = 0
    case neonPinkSmall = 1
    case neonBlueBig = 2
    case neonBlueSmall = 3
    case icon = 4
    case text = 5
}

/// Peers buttons
@IBDesignable open class PeersButton: UIButton {
    
    private var defaultBackgoundStyle: Int = 1
    private var customBackgroundColor: UIColor = UIColor.white
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override open var isHighlighted: Bool {
        didSet {
            let highlightedColor = darken(color: customBackgroundColor)
            backgroundColor = isHighlighted ? highlightedColor : customBackgroundColor
        }
    }
    
    @IBInspectable public var style: Int = 1 {
        didSet {
            defaultBackgoundStyle = style
            if style < PeersButtonStyle.allCases.count {
                buttonStyle = PeersButtonStyle(rawValue: style)!
            } else {
                buttonStyle = PeersButtonStyle(rawValue: 0)!
            }
        }
    }
    
    var buttonStyle: PeersButtonStyle = .neonPinkSmall {
        didSet {
            switch buttonStyle {
            case .neonPinkBig:
                setTintColor(UIColor.white)
                setBackgroundColor(PeersColors.neonPink.color)
                titleLabel?.font = PeersFonts.BarlowSemiCondensed.semiBold.font(size: 27)
            case .neonPinkSmall:
                setTintColor(UIColor.white)
                setBackgroundColor(PeersColors.neonPink.color)
                titleLabel?.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 22)
            case .neonBlueBig:
                setTintColor(PeersColors.darkBlue.color)
                setBackgroundColor(PeersColors.neonBlue.color)
                titleLabel?.font = PeersFonts.BarlowSemiCondensed.semiBold.font(size: 27)
            case .neonBlueSmall:
                setTintColor(PeersColors.darkBlue.color)
                setBackgroundColor(PeersColors.neonBlue.color)
                titleLabel?.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 22)
            case .icon:
                setTintColor(UIColor.clear)
                setBackgroundColor(UIColor.clear)
            case .text:
                setTintColor(PeersColors.darkGrey.color)
                setBackgroundColor(UIColor.white)
                titleLabel?.font = PeersFonts.BarlowSemiCondensed.light.font(size: 17)
            default:
                setTintColor(UIColor.white)
                setBackgroundColor(PeersColors.neonPink.color)
                titleLabel?.font = PeersFonts.BarlowSemiCondensed.medium.font(size: 22)
            }
            layer.cornerRadius = 8
            contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 13, right: 10)
        }
    }
    
    open func reset() {
        self.style = defaultBackgoundStyle
    }
    
    private func setTintColor(_ peersTintColor: UIColor) {
        setTitleColor(peersTintColor, for: .normal)
    }
    
    open func setBackgroundColor(_ peersBackgroundColor: UIColor) {
        backgroundColor = peersBackgroundColor
        customBackgroundColor = peersBackgroundColor
    }
    
    private func darken(color: UIColor, by percentage: CGFloat = -10.0) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return color
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            if(!isEnabled) {
                alpha = 0.5
            } else {
                alpha = 1.0
            }
        }
    }
    
}
