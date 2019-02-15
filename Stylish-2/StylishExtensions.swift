//
//  StylishExtensions.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

// MARK: - =? Operator -

// Optional assignment operator. Assigns the optional value on the right (if not nil) to the variable on the left. If the optional on the right is nil, then no action is performed

infix operator =? : AssignmentPrecedence

func =?<T>( left:inout T, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}

func =?<T>( left:inout T!, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}


func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
    -> Dictionary<K,V>
{
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}

// MARK: String.isVariantOf() Extension

// String extensions for being forgiving of different styles of string representation and capitalization

extension String {
    func isVariant(of string:String) -> Bool {
        let components = string.components(separatedBy: " ")
        return self == string  //"Example Test String"
            || self == string.lowercased() //"example test string"
            || self == string.lowercased().replacingOccurrences(of:" ", with: "") //"exampleteststring"
            || self == string.replacingOccurrences(of:" ", with: "") //"ExampleTestString"
            || self == string.lowercased().replacingOccurrences(of:" ", with: "-") //"example-test-string
            || self == string.lowercased().replacingOccurrences(of:" ", with: "_") //"example_test_string
            || self == (components.count > 1 ? components.first!.lowercased() + components[1..<components.count].flatMap{$0.capitalized}.joined(separator: "") : string) //"exampleTestString"
            || self.lowercased().replacingOccurrences(of:" ", with: "") == string.lowercased().replacingOccurrences(of:" ", with: "") //"EXample String" != "Example String" -> "examplestring" == "examplestring"
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy:1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 || hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0xff000000) >> 24) / 255 : CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0x00ff0000) >> 16) / 255 : CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0x0000ff00) >> 8) / 255 : CGFloat(hexNumber & 0x000000ff) / 255
                    a = hexColor.characters.count == 8 ? CGFloat(hexNumber & 0x000000ff) / 255 : 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        self.init()
        return nil
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgba:Int = (Int)(r*255)<<24 | (Int)(g*255)<<16 | (Int)(b*255)<<8 | (Int)(a*255)<<0

        return String(format:"#%08x", rgba)
    }
}

//public extension UIFont {
//    struct SimplifiedFont {
//        var fontName: String?
//        var fontWeight: String?
//        var fontSize: CGFloat?
//        
//        init(name:String?, weight: String?, size: Float?) {
//            self.fontName = name
//            self.fontWeight = weight
//            
//            self.fontSize = size != nil ? CGFloat(size!) : 0
//        }
//        
//        func createFont(_ baseFont: UIFont) -> UIFont {
//            let currentFont = baseFont
//            
//            var fontName = ((self.fontName) != nil) ? self.fontName : currentFont.fontName
//            if let _ = self.fontWeight {
//                if let dashRange = fontName?.range(of: "-") {
//                    fontName?.removeSubrange(dashRange.lowerBound..<(fontName?.endIndex)!)
//                }
//            }
//            
//            fontName = (self.fontWeight != nil && fontName?.range(of: fontWeight!) == nil) ? fontName! + "-" + self.fontWeight! : fontName
//            let fontSize = (self.fontSize != 0) ? self.fontSize : currentFont.pointSize
//            
//            if let font = UIFont(name: fontName!, size: fontSize!) {
//                return font
//            } else {
//                print("!!!!StylishError!!!! Invalid font name \(String(describing: fontName))")
//                return UIFont(name: "HelveticaNeue", size: 12)!
//            }
//        }
//    }
//}

extension NSObject {
    func getTypeOfProperty (_ name: String) -> String? {

        var type: Mirror = Mirror(reflecting: self)

        for child in type.children {
            if child.label! == name {
                return String(describing: Swift.type(of: child.value))
            }
        }
        while let parent = type.superclassMirror {
            for child in parent.children {
                if child.label! == name {
                    return String(describing: Swift.type(of: child.value))
                }
            }
            type = parent
        }
        return nil
    }
    
    func retriveDynamicPropertySet(prefix: String = "") ->Dictionary<String, Any> {
        var count: UInt32 = 0
        
        guard let properties = class_copyPropertyList(self.classForCoder, &count) else {
            return [:]
        }
        
        var propertySet: Dictionary<String, Any> = Dictionary()
        for index in 0...count - 1 {
            let property = property_getName(properties[Int(index)])
            let result = String(cString: property)
            propertySet.updateValue(NSNull(), forKey: prefix + result)
        }
        
        return propertySet
    }
    
    func setStyleProperties(value: Any, key: String) {
        if !(value is NSNull) {
            if key.range(of:".") != nil {
                self.setValue(value, forKeyPath: key)
            } else {
                self.setValue(value, forKey: key)
            }
        }
    }
}
