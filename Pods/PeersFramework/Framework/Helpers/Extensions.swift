import Foundation

// Generating debugging descriptions for any class
// that implements CustomStringConvertible, e.g. NSObject.
extension CustomStringConvertible {
    public var description: String {
        var description: String = "\(type(of: self))("
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value), "
            }
        }
        description += "<\(Unmanaged.passUnretained(self as AnyObject).toOpaque())>)"
        return description
    }
}

// Add minutes, seconds etc. to an existing Date.
extension Date {
    func add(_ type: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: type, value: value, to: Date())!
    }
}
