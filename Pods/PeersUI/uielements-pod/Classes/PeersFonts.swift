//
//  PeersFonts.swift
//  Pods-uielements-pod_Example
//
//  Created by Benjamin Kramser on 27.05.19.
//

#if os(OSX)
    import AppKit.NSFont
    internal typealias Font = NSFont
#elseif os(iOS)
    import UIKit.UIFont
    internal typealias Font = UIFont
#endif

/// The peers fonts
public enum PeersFonts {
    public enum BarlowSemiCondensed {
        public static let bold = FontConvertible(name: "BarlowSemiCondensed-Bold", family: "BarlowSemiCondensed", path: "BarlowSemiCondensed-Bold.ttf")
        public static let semiBold = FontConvertible(name: "BarlowSemiCondensed-SemiBold", family: "BarlowSemiCondensed", path: "BarlowSemiCondensed-SemiBold.ttf")
        public static let medium = FontConvertible(name: "BarlowSemiCondensed-Medium", family: "BarlowSemiCondensed", path: "BarlowSemiCondensed-Medium.ttf")
        public static let light = FontConvertible(name: "BarlowSemiCondensed-Light", family: "BarlowSemiCondensed", path: "BarlowSemiCondensed-Light.ttf")
        public static let all: [FontConvertible] = [bold, semiBold, medium, light]
    }
    public enum RockSalt {
        public static let regular = FontConvertible(name: "RockSalt-Regular", family: "RockSalt", path: "RockSalt-Regular.ttf")
        public static let all: [FontConvertible] = [regular]
    }
    static let allCustomFonts: [FontConvertible] = [BarlowSemiCondensed.all, RockSalt.all].flatMap { $0 }
    static func registerAllCustomFonts() {
        allCustomFonts.forEach { $0.register() }
    }
}

/// A wrapper to register fonts
public struct FontConvertible {
    let name: String
    let family: String
    let path: String
    
    /// Creates a font with a specified size
    /// - Parameters:
    ///   - size: the font size
    /// - Returns: the created font
    func font(size: CGFloat) -> Font! {
        return Font(font: self, size: size)
    }
    
    /// Sets the font url of the font to be registered (needed for the bundle)
    func register() {
        guard let url = url else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    
    fileprivate var url: URL? {
        let bundle = Bundle(for: BundleToken.self)
        return bundle.url(forResource: path, withExtension: nil)
    }
    
}

extension Font {
    
    /// Creates a font, based on a FontConvertible
    /// - Parameters:
    ///   - font: the FontConvertible, that contains all necessary information about the font, that should be created
    ///   - size: the size of the font
    convenience init!(font: FontConvertible, size: CGFloat) {
        #if os(iOS) || os(tvOS) || os(watchOS)
        if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
            font.register()
        }
        #elseif os(OSX)
        if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
            font.register()
        }
        #endif
        
        self.init(name: font.name, size: size)
        
    }
}

private final class BundleToken {}



