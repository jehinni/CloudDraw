
import Foundation
import UIKit

@IBDesignable open class GradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.white
    @IBInspectable var endColor: UIColor = UIColor.white
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override open func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [startColor.cgColor, endColor.cgColor]
    }

}
