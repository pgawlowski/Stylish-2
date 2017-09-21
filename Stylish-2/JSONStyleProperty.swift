//
//  JSONStyleProperty.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation

public enum JSONStyleProperty {
    case CGFloatProperty(value:CGFloat)
    case FloatProperty(value:Float)
    case DoubleProperty(value:Double)
    case IntProperty(value:Int)
    case BoolProperty(value:Bool)
    case UIEdgeInsetsProperty(value:UIEdgeInsets)
    case NSTextAlignmentProperty(value:NSTextAlignment)
    case UITextBorderStyleProperty(value:UITextBorderStyle)
    case StringProperty(value:String)
    case UIColorProperty(value:UIColor)
    case CGColorProperty(value:CGColor)
    case UIImageProperty(value:UIImage)
    case UIViewContentModeProperty(value:UIViewContentMode)
    case UIFontProperty(value: SimplifiedFont)
    case InvalidProperty(errorMessage:String)
    case PropertyType(value:String)
    
    init() {
        self = .InvalidProperty(errorMessage: "Empty 'propertyValue'")
    }
    
    init(propertyType: String?, value: Any?) {
        guard let type = propertyType else {
            self = .InvalidProperty(errorMessage: "Missing value for 'propertyType' in JSON")
            return
        }
        
        self = .PropertyType(value: type)
        self.mutate(value: value)
    }
    
    public mutating func mutate(value: Any?) {
        let check:(Any?, String) -> (Any?, JSONStyleProperty?) = {testValue, type in
            guard testValue != nil else {
                return (nil, .InvalidProperty(errorMessage: String(format:"'propertyValue' in JSON was missing or could not be converted to %@", type)))
            }
            return (testValue, nil)
        }
        
        if let value = value {
            if self.mapPrimitives(value: value as AnyObject, checkClosure: check) { return }
            if self.mapEnums(value: value as AnyObject, checkClosure: check) { return }
            if self.mapObjects(value: value as AnyObject, checkClosure: check) { return }
        }
        self = .InvalidProperty(errorMessage: "Missing 'propertyValue' check data value types")
    }
    
    private mutating func mapPrimitives(value: AnyObject, checkClosure:(Any?, String) -> (Any?, JSONStyleProperty?)) -> Bool {
        if let type = self.rawValue as? String {
            switch type {
            case _ where type.isVariant(of: "CG Float") :
                let tuple = checkClosure(value as? CGFloat, type)
                self = (tuple.0 != nil) ? .CGFloatProperty(value: tuple.0 as! CGFloat) : tuple.1!
                break
            case _ where type.isVariant(of: "Float") :
                let tuple = checkClosure(value as? Float, type)
                self = (tuple.0 != nil) ? .FloatProperty(value: tuple.0 as! Float) : tuple.1!
                break
            case _ where type.isVariant(of: "Double") :
                let tuple = checkClosure(value as? Double, type)
                self = (tuple.0 != nil) ? .DoubleProperty(value: tuple.0 as! Double) : tuple.1!
                break
            case _ where type.isVariant(of: "Int") :
                let tuple = checkClosure(value as? Int, type)
                self = (tuple.0 != nil) ? .IntProperty(value: tuple.0 as! Int) : tuple.1!
                break
            case _ where type.isVariant(of: "Bool") :
                let tuple = checkClosure(value as? Bool, type)
                self = (tuple.0 != nil) ? .BoolProperty(value: tuple.0 as! Bool) : tuple.1!
                break
            case _ where type.isVariant(of: "CGColor") :
                let tuple = checkClosure(value as? String, value as! String)
                if tuple.0 != nil, let value = UIColor(hexString:(tuple.0 as! String))?.cgColor {
                    self = .CGColorProperty(value: value)
                } else {
                    self = tuple.1!
                }
                break
            case _ where type.isVariant(of: "UI Edge Insets") || type.isVariant(of: "Edge Insets"):
                if let value = value as? NSDictionary {
                    guard let top = (value["top"] as? NSNumber)?.floatValue,
                        let left = (value["left"] as? NSNumber)?.floatValue,
                        let bottom = (value["bottom"] as? NSNumber)?.floatValue,
                        let right = (value["right"] as? NSNumber)?.floatValue else {
                            self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain values for 'top', 'left', 'bottom', and 'right' that could be converted to Floats")
                            return true
                    }
                    let tuple = checkClosure(UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right)) as UIEdgeInsets, type)
                    self = (tuple.0 != nil) ? .UIEdgeInsetsProperty(value: tuple.0 as! UIEdgeInsets) : tuple.1!
                }
                break
                
            default:
                return false
            }
        } else {
            return false
        }
        
        return true
    }
    
    private mutating func mapObjects(value: Any, checkClosure:(Any?, String) -> (Any?, JSONStyleProperty?)) -> Bool {
        guard let type: AnyClass = NSClassFromString(self.rawValue as! String) else {
            self = .InvalidProperty(errorMessage: "Invalid 'propertyType' in JSON - check NSObject types")
            return false
        }
        
        switch type {
        case is String.Type:
            let tuple = checkClosure(value as? String, value as! String)
            self = (tuple.0 != nil) ? .StringProperty(value: tuple.0 as! String) : tuple.1!
            break
        case is UIColor.Type:
            let tuple = checkClosure(value as? String, value as! String)
            if tuple.0 != nil, let value = UIColor(hexString:(tuple.0 as! String)) {
                self = .UIColorProperty(value: value)
            } else {
                self = tuple.1!
            }
            break
        case is UIImage.Type:
            let tuple = checkClosure(value as? String, value as! String)
            if tuple.0 != nil, let value = UIImage(named: tuple.0 as! String) {
                self = .UIImageProperty(value: value)
            } else {
                self = tuple.1!
            }
            break
        case is UIFont.Type:
            if value is NSDictionary {
                let font = SimplifiedFont.init(dictionary: value as! NSDictionary)
                self = .UIFontProperty(value: font)
            }
            break
        default:
            return false
        }
        
        return true
    }
    
    private mutating func mapEnums(value: Any, checkClosure:(Any?, String) -> (Any?, JSONStyleProperty?)) -> Bool {
        if let type = self.rawValue as? String {
            switch type {
            case _ where type.isVariant(of: "NSTextAlignment") || type.isVariant(of: "Text Alignment") :
                let tuple = checkClosure(value as? String, type)
                let value: String = (tuple.0 != nil) ? tuple.0 as! String : ""
                
                switch value {
                case _ where value.isVariant(of: "Left") :
                    self = .NSTextAlignmentProperty(value: .left)
                case _ where value.isVariant(of: "Center") :
                    self = .NSTextAlignmentProperty(value: .center)
                case _ where value.isVariant(of: "Right") :
                    self = .NSTextAlignmentProperty(value: .right)
                case _ where value.isVariant(of: "Justified") :
                    self = .NSTextAlignmentProperty(value: .justified)
                case _ where value.isVariant(of: "Natural") :
                    self = .NSTextAlignmentProperty(value: .natural)
                default :
                    self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for an NSTextAlignment property, i.e. 'Left', 'Center', 'Right', 'Justified', 'Natural'")
                }
                break
                
            case _ where type.isVariant(of: "UITextBorderStyle") || type.isVariant(of: "Text Border Style"):
                let tuple = checkClosure(value as? String, type)
                let value: String = (tuple.0 != nil) ? tuple.0 as! String : ""
                
                switch value {
                case _ where value.isVariant(of: "bezel"):
                    self = .UITextBorderStyleProperty(value: .bezel)
                case _ where value.isVariant(of: "line"):
                    self = .UITextBorderStyleProperty(value: .line)
                case _ where value.isVariant(of: "none"):
                    self = .UITextBorderStyleProperty(value: .none)
                case _ where value.isVariant(of: "roundedRect"):
                    self = .UITextBorderStyleProperty(value: .roundedRect)
                default :
                    self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for an UITextBorderStyle property, i.e. 'bezel', 'line', 'none', 'roundedRect'")
                }
                break
                
            case _ where type.isVariant(of: "UI View Content Mode") || type.isVariant(of: "View Content Mode") || type.isVariant(of: "Content Mode") :
                let tuple = checkClosure(value as? String, type)
                let value: String = (tuple.0 != nil) ? tuple.0 as! String : ""
                
                switch value {
                case _ where value.isVariant(of: "Scale To Fill") :
                    self = .UIViewContentModeProperty(value: .scaleToFill)
                case _ where value.isVariant(of: "Scale Aspect Fit") :
                    self = .UIViewContentModeProperty(value: .scaleAspectFit)
                case _ where value.isVariant(of: "Scale Aspect Fill") :
                    self = .UIViewContentModeProperty(value: .scaleAspectFill)
                case _ where value.isVariant(of: "Redraw") :
                    self = .UIViewContentModeProperty(value: .redraw)
                case _ where value.isVariant(of: "Center") :
                    self = .UIViewContentModeProperty(value: .center)
                case _ where value.isVariant(of: "Top") :
                    self = .UIViewContentModeProperty(value: .top)
                case _ where value.isVariant(of: "Bottom") :
                    self = .UIViewContentModeProperty(value: .bottom)
                case _ where value.isVariant(of: "Left") :
                    self = .UIViewContentModeProperty(value: .left)
                case _ where value.isVariant(of: "Right") :
                    self = .UIViewContentModeProperty(value: .right)
                case _ where value.isVariant(of: "Top Left") :
                    self = .UIViewContentModeProperty(value: .topLeft)
                case _ where value.isVariant(of: "Top Right") :
                    self = .UIViewContentModeProperty(value: .topRight)
                case _ where value.isVariant(of: "Bottom Left") :
                    self = .UIViewContentModeProperty(value: .bottomLeft)
                case _ where value.isVariant(of: "Bottom Right") :
                    self = .UIViewContentModeProperty(value: .bottomRight)
                default :
                    self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for a UIViewContentMode property, e.g. 'scaleToFill', 'scaleAspectFit', 'Center', 'topRight', etc.")
                }
                break
            default:
                return false
            }
        } else {
            return false
        }
        
        return true
    }

    public var rawValue:Any {
        switch self {
        case .CGFloatProperty(let value):
            return value
        case .FloatProperty(let value):
            return value
        case .DoubleProperty(let value):
            return value
        case .IntProperty(let value):
            return value
        case .BoolProperty(let value):
            return value
        case .UIEdgeInsetsProperty(let value):
            return value
        case .NSTextAlignmentProperty(let value):
            return value.rawValue
        case .UITextBorderStyleProperty(let value):
            return value.rawValue
        case .StringProperty(let value):
            return value
        case .UIColorProperty(let value):
            return value
        case .CGColorProperty(let value):
            return value
        case .UIImageProperty(let value):
            return value
        case .UIViewContentModeProperty(let value):
            return value.rawValue
        case .UIFontProperty(let value):
            return value
        case .InvalidProperty(let value):
            return value
        case .PropertyType(let value):
            return value
        }
    }
}
