//
//  JSONStyleProperty.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation

public class StyleProperty {

    //Primitives
    internal typealias funcCGFloat  = (CGFloat) -> JSONStyleProperty
    internal typealias funcFloat    = (Float)   -> JSONStyleProperty
    internal typealias funcDouble   = (Double)  -> JSONStyleProperty
    internal typealias funcInt      = (Int)     -> JSONStyleProperty
    internal typealias funcBool     = (Bool)    -> JSONStyleProperty
    internal typealias funcCGColor  = (String)  -> JSONStyleProperty
    internal typealias funcUIEdgeInsets = (Dictionary<String, NSNumber>) -> JSONStyleProperty

    internal static let toCGFloat   : funcCGFloat   = { return JSONStyleProperty.CGFloatProperty(value: $0) }
    internal static let toFloat     : funcFloat     = { return JSONStyleProperty.FloatProperty(value: $0) }
    internal static let toDouble    : funcDouble    = { return JSONStyleProperty.DoubleProperty(value: $0) }
    internal static let toInt       : funcInt       = { return JSONStyleProperty.IntProperty(value: $0) }
    internal static let toBool      : funcBool      = { return JSONStyleProperty.BoolProperty(value: $0) }
    internal static let toCGColor   : funcCGColor   = { return JSONStyleProperty.CGColorProperty(value: (UIColor(hexString:$0)?.cgColor)!) }
    internal static let toUIEdgeInsets : funcUIEdgeInsets = { dict in
        let top = CGFloat(dict["top"]?.floatValue ?? 0)
        let bottom = CGFloat(dict["bottom"]?.floatValue ?? 0)
        let left = CGFloat(dict["left"]?.floatValue ?? 0)
        let right = CGFloat(dict["right"]?.floatValue ?? 0)
        
        return JSONStyleProperty.UIEdgeInsetsProperty(value: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    //Enums
    internal typealias funcNSTextAlignment      = (String) -> JSONStyleProperty
    internal typealias funcUITextBorderStyle    = (String) -> JSONStyleProperty
    internal typealias funcUIViewContentMode    = (String) -> JSONStyleProperty

    
    public init() {}
    
    internal static let toNSTextAlignment   : funcNSTextAlignment =  {
        switch $0 {
        case _ where $0.isVariant(of: "Left")       :   return JSONStyleProperty.NSTextAlignmentProperty(value: .left)
        case _ where $0.isVariant(of: "Right")      :   return JSONStyleProperty.NSTextAlignmentProperty(value: .right)
        case _ where $0.isVariant(of: "Center")     :   return JSONStyleProperty.NSTextAlignmentProperty(value: .center)
        case _ where $0.isVariant(of: "Justified")  :   return JSONStyleProperty.NSTextAlignmentProperty(value: .justified)
        case _ where $0.isVariant(of: "natural")    :   return JSONStyleProperty.NSTextAlignmentProperty(value: .natural)

        default:                                            return JSONStyleProperty.InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for an NSTextAlignment property, i.e. 'Left', 'Center', 'Right', 'Justified', 'Natural'")
        }
    }
    
    internal static let toUITextBorderStyle : funcUITextBorderStyle =  {
        switch $0 {
        case _ where $0.isVariant(of: "bezel"):     return JSONStyleProperty.UITextBorderStyleProperty(value: .bezel)
        case _ where $0.isVariant(of: "line"):      return JSONStyleProperty.UITextBorderStyleProperty(value: .line)
        case _ where $0.isVariant(of: "none"):      return JSONStyleProperty.UITextBorderStyleProperty(value: .none)
        case _ where $0.isVariant(of: "roundedRect"):return JSONStyleProperty.UITextBorderStyleProperty(value: .roundedRect)
        default :                                   return JSONStyleProperty.InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for an UITextBorderStyle property, i.e. 'bezel', 'line', 'none', 'roundedRect'")
        }
    }
    
    internal static let toUIViewContentMode : funcUIViewContentMode =  {
        switch $0 {
        case _ where $0.isVariant(of: "Scale To Fill"):     return JSONStyleProperty.UIViewContentModeProperty(value: .scaleToFill)
        case _ where $0.isVariant(of: "Scale Aspect Fit"):  return JSONStyleProperty.UIViewContentModeProperty(value: .scaleAspectFit)
        case _ where $0.isVariant(of: "Scale Aspect Fill"): return JSONStyleProperty.UIViewContentModeProperty(value: .scaleAspectFill)
        case _ where $0.isVariant(of: "Redraw"):            return JSONStyleProperty.UIViewContentModeProperty(value: .redraw)
        case _ where $0.isVariant(of: "Center"):            return JSONStyleProperty.UIViewContentModeProperty(value: .center)
        case _ where $0.isVariant(of: "Top"):               return JSONStyleProperty.UIViewContentModeProperty(value: .top)
        case _ where $0.isVariant(of: "Bottom"):            return JSONStyleProperty.UIViewContentModeProperty(value: .bottom)
        case _ where $0.isVariant(of: "Left"):              return JSONStyleProperty.UIViewContentModeProperty(value: .left)
        case _ where $0.isVariant(of: "Right"):             return JSONStyleProperty.UIViewContentModeProperty(value: .right)
        case _ where $0.isVariant(of: "Top Left"):          return JSONStyleProperty.UIViewContentModeProperty(value: .topLeft)
        case _ where $0.isVariant(of: "Top Right"):         return JSONStyleProperty.UIViewContentModeProperty(value: .topRight)
        case _ where $0.isVariant(of: "Bottom Left"):       return JSONStyleProperty.UIViewContentModeProperty(value: .bottomLeft)
        case _ where $0.isVariant(of: "Bottom Right"):      return JSONStyleProperty.UIViewContentModeProperty(value: .bottomRight)
        default:                                            return JSONStyleProperty.InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for a UIViewContentMode property, e.g. 'scaleToFill', 'scaleAspectFit', 'Center', 'topRight', etc.")
        }
    }
    
    //Objects
    internal typealias funcString   = (String) -> JSONStyleProperty
    internal typealias funcUIColor  = (String) -> JSONStyleProperty
    internal typealias funcUIImage  = (String) -> JSONStyleProperty
    internal typealias funcUIFont   = (NSDictionary) -> JSONStyleProperty
    
    internal static let toString    : funcString    = { return JSONStyleProperty.StringProperty(value: $0) }
    internal static let toUIColor   : funcUIColor   = { return JSONStyleProperty.UIColorProperty(value: UIColor(hexString: $0)!) }
    internal static let toUIImage   : funcUIImage   = { return JSONStyleProperty.UIImageProperty(value: UIImage(named: $0)!) }
    internal static let toUIFont    : funcUIFont    = {
        return JSONStyleProperty.UIFontProperty(value: SimplifiedFont(dictionary: $0))
    }
    
    internal let fromDictionary: Dictionary =
        [
            "CGFloat"   : toCGFloat,
            "Float"     : toFloat,
            "Double"    : toDouble,
            "Int"       : toInt,
            "Bool"      : toBool,
            "CGColor"   : toCGColor,
            "UIEdgeInsets" : toUIEdgeInsets,
            
            "NSTextAlignment" : toNSTextAlignment,
            "UITextBorderStyle" : toUITextBorderStyle,
            "UIViewContentMode" : toUIViewContentMode,
            
            "String" : toString,
            "UIColor" : toUIColor,
            "UIFont" : toUIFont,
        ] as [String : Any]
    
    public func jsonStyleProperty(value: Any, type: String) -> JSONStyleProperty {
        let checkClosure:(Any?, String) -> (Any?, JSONStyleProperty?) = {testValue, type in
            guard testValue != nil else {
                return (nil, .InvalidProperty(errorMessage: String(format:"'propertyValue' in JSON was missing or could not be converted to %@", type)))
            }
            return (testValue, nil)
        }

        if let val = self.parsePrimitives(checkClosure, value, type) { return val }
        if let val = self.parseEnums(checkClosure, value, type) { return val }
        if let val = self.parseObject(checkClosure, value, type) { return val }
        
        return .InvalidProperty(errorMessage: String(format:"'propertyValue' in JSON was missing or could not be converted to %@", type))
    }
    
    func parsePrimitives(_ checkClosure: (Any?, String) -> (Any?, JSONStyleProperty?),_ value: Any, _ type: String) -> JSONStyleProperty? {
        switch self.fromDictionary[type] {
        case let parseFunc as funcCGFloat:
            let tuple = checkClosure(value as? CGFloat, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! CGFloat) : tuple.1!
        case let parseFunc as funcFloat:
            let tuple = checkClosure(value as? Float, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! Float) : tuple.1!
        case let parseFunc as funcDouble:
            let tuple = checkClosure(value as? Double, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! Double) : tuple.1!
        case let parseFunc as funcInt:
            let tuple = checkClosure(value as? Int, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! Int) : tuple.1!
        case let parseFunc as funcBool:
            let tuple = checkClosure(value as? Bool, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! Bool) : tuple.1!
        case let parseFunc as funcCGColor:
            let tuple = checkClosure(value as? String, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! String) : tuple.1!
        case let parseFunc as funcUIEdgeInsets:
            let tuple = checkClosure(value as? Dictionary<String, NSNumber>, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! Dictionary<String, NSNumber>) : tuple.1!
        default:
            return nil
        }
    }
    
    func parseEnums(_ checkClosure: (Any?, String) -> (Any?, JSONStyleProperty?),_ value: Any, _ type: String) -> JSONStyleProperty? {
        switch self.fromDictionary[type] {
        case let parseFunc as funcNSTextAlignment where type == "NSTextAlignment":
            let tuple = checkClosure(value as? String, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! String) : tuple.1!
        case let parseFunc as funcUITextBorderStyle where type == "UITextBorderStyle":
            let tuple = checkClosure(value as? String, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! String) : tuple.1!
        case let parseFunc as funcUITextBorderStyle where type == "UIViewContentMode":
            let tuple = checkClosure(value as? String, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! String) : tuple.1!
        default:
            return nil
        }
    }
    
    func parseObject(_ checkClosure: (Any?, String) -> (Any?, JSONStyleProperty?),_ value: Any, _ type: String) -> JSONStyleProperty? {
        switch self.fromDictionary[type] {
        case let parseFunc as funcString where type == "String":
            let tuple = checkClosure(value as? String, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! String) : tuple.1!
        case let parseFunc as funcUIColor where type == "UIColor":
            let tuple = checkClosure(value as? String, type)
            return (tuple.0 != nil) ? parseFunc(tuple.0 as! String) : tuple.1!
        case let parseFunc as funcUIFont where type == "UIFont":
            return parseFunc(value as! NSDictionary)
        default:
            return nil
        }
    }
}

public enum JSONStyleProperty {
    case CGFloatProperty(value:CGFloat)
    case FloatProperty(value:Float)
    case DoubleProperty(value:Double)
    case IntProperty(value:Int)
    case BoolProperty(value:Bool)
    case UIEdgeInsetsProperty(value:UIEdgeInsets)
    case NSTextAlignmentProperty(value:NSTextAlignment)
    case UITextBorderStyleProperty(value:UITextField.BorderStyle)
    case StringProperty(value:String)
    case UIColorProperty(value:UIColor)
    case CGColorProperty(value:CGColor)
    case UIImageProperty(value:UIImage)
    case UIViewContentModeProperty(value:UIView.ContentMode)
    case UIFontProperty(value: SimplifiedFont)
    case InvalidProperty(errorMessage:String)
    case PropertyType(value:String)
    
    init() {
        self = .InvalidProperty(errorMessage: "Empty 'propertyValue'")
    }

    public var rawValue:Any {
        switch self {
        case .CGFloatProperty(let value):   return value
        case .FloatProperty(let value):     return value
        case .DoubleProperty(let value):    return value
        case .IntProperty(let value):       return value
        case .BoolProperty(let value):      return value
        case .UIEdgeInsetsProperty(let value): return value
        case .NSTextAlignmentProperty(let value): return value.rawValue
        case .UITextBorderStyleProperty(let value): return value.rawValue
        case .StringProperty(let value):    return value
        case .UIColorProperty(let value):   return value
        case .CGColorProperty(let value):   return value
        case .UIImageProperty(let value):   return value
        case .UIViewContentModeProperty(let value): return value.rawValue
        case .UIFontProperty(let value):    return value
        case .InvalidProperty(let value):   return value
        case .PropertyType(let value):      return value
        }
    }
    
    public var dictionaryValue: Any {
        switch self {
        case .CGFloatProperty(let value):   return value
        case .FloatProperty(let value):     return value
        case .DoubleProperty(let value):    return value
        case .IntProperty(let value):       return value
        case .BoolProperty(let value):      return value
        case .UIEdgeInsetsProperty(let value):
            return [
                "top" : value.top.description,
                "bottom" : value.bottom.description,
                "left" : value.left.description,
                "right" : value.right.description,
            ]
        case .NSTextAlignmentProperty(let value):
            switch value {
            case .left:         return "left"
            case .right:        return "right"
            case .center:       return "center"
            case .justified:    return "justified"
            case .natural:      return "natural"
            }
        case .UITextBorderStyleProperty(let value):
            switch value {
            case .bezel:        return "bezel"
            case .none:         return "none"
            case .roundedRect:  return "roundedRect"
            case .line:         return "line"
            }
        case .StringProperty(let value):    return value
        case .UIColorProperty(let value):   return value.toHexString()
        case .CGColorProperty(let value):   return UIColor(cgColor: value).toHexString()
        case .UIImageProperty(let value):   return value
        case .UIViewContentModeProperty(let value): return String(describing: value)
        case .UIFontProperty(let value):
            return [
                "fontName" : value.fontName,
                "weight" : value.weight,
                "pointSize" : value.pointSize?.description
            ]
        default: return ""
        }
    }
}
