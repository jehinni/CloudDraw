//
//  PeersImages.swift
//  Pods-uielements
//
//  Created by Benjamin Kramser on 27.05.19.

#if os(OSX)
    import AppKit.NSImage
    public typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    public typealias AssetImageTypeAlias = UIImage
#endif

/// List of Peers Images
public enum PeersImages {
    
    public static let appIcon = ImageAsset(name: "App-Logo")
    public static let edit = ImageAsset(name: "edit")
    public static let profile = ImageAsset(name: "profile")
    public static let background = ImageAsset(name: "background")
    public static let change = ImageAsset(name: "switch")
    public static let allImages = [ PeersImages.appIcon, PeersImages.edit, PeersImages.profile, PeersImages.background,  PeersImages.change]
    
}

/// Creates images for image resources from the assets folder
public struct ImageAsset {
    
    public fileprivate(set) var name: String
    
    /// The acutal image, created dependently on os
    public var image: AssetImageTypeAlias {
        let bundle = Bundle(for: BundleToken.self)
        
        #if os(iOS) || os(tvOS)
            let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            let image = bundle.image(forResource: NSImage.Name(name))
        #endif
        guard let result = image else { fatalError("Unable to load image named \(name).")}
        return result
        
    }
        
}

/// An extension of the UIImage/NSImage class to create images in project
public extension AssetImageTypeAlias {
    @available(iOS 1.0, tvOS 1.0, *)
    @available(OSX, deprecated, message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    
    /// Creates an Image (UIImage/NSImage) out of a AssetImage
    /// - Parameters:
    ///   - asset: the ImageAsset that should be "converted"
    convenience init!(asset: ImageAsset) {
        #if os(iOS) || os(tvOS)
        let bundle = Bundle(for: BundleToken.self)
        self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
        self.init(named: NSImage.Name(asset.name))
        #endif
    }
}
        
/// The helper class for loading the images from the assets folder
private final class BundleToken {}


/// extension for UIImage creation with size parameter or with insets 
extension UIImage {
    
    /// Creates a UIImage, dependent on size; default has width equals to height
    /// - Parameters:
    ///   - size: the size of the Image
    convenience init?(size: CGSize = CGSize(width: 1, height: 1)) {

        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }

    /// Creates an image with specified insets
    /// - Parameters:
    ///   - insets: the insets for all four corners
    /// - Returns: the UIImage with the specified insets
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size.width + insets.left + insets.right,
                   height: size.height + insets.top + insets.bottom),
            false,
            self.scale)
        
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithInsets
    }

}





