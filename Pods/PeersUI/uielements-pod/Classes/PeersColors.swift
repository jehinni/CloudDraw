//
//  PeersColors.swift
//  uielements-pod
//
//  Created by Manuela Müller on 26.05.19.


#if os(OSX)
import AppKit.NSColor
public typealias AssetColorTypeAlias = NSColor
#elseif os(iOS) || os (tvOS)
import UIKit.UIColor
public typealias AssetColorTypeAlias = UIColor
#endif


/// The different peers colours
public enum PeersColors {
    
    public static let neonBlue = ColorAsset(name: "neonBlue")
    public static let neonBlueDarker = ColorAsset(name: "neonBlueDarker")
    public static let neonPink = ColorAsset(name: "neonPink")
    public static let neonPinkDarker = ColorAsset(name: "neonPinkDarker")
    public static let lightPink = ColorAsset(name: "lightPink")
    public static let darkBlue = ColorAsset(name: "darkBlue")
    public static let lightGrey = ColorAsset(name: "lightGrey")
    public static let darkGrey = ColorAsset(name: "darkGrey")
    public static let intensePurple = ColorAsset(name: "intensePurple")
    public static let brightPurple = ColorAsset(name: "brightPurple")
    public static let bluePurple = ColorAsset(name: "bluePurple")
    public static let darkPurple = ColorAsset(name: "darkPurple")
    public static let green = ColorAsset(name: "green")
    public static let red = ColorAsset(name: "red")
    public static let rosePink = ColorAsset(name: "rosePink")
}

public struct ColorAsset {
    
    public fileprivate(set) var name: String
    
    public var color: AssetColorTypeAlias {
        return AssetColorTypeAlias(asset: self)
    }
}

/// UIColor/NSColor extension to instanciate a color out of a ColorAsset
public extension AssetColorTypeAlias {
    
    /// Creates a color based on a ColorAsset
    convenience init!(asset: ColorAsset) {
        let bundle = Bundle(for: BundleToken.self)
        
        #if os(iOS) || os(tvOS)
        self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
        self.init(named: NSColor.Name(asset.name), bundle: bundle)
        #endif
    }
}
        
private final class BundleToken {}

