//
//  StyleClass.swift
//  Styling App
//
//  Created by Michal Niemiec on 08/06/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import UIKit
import ObjectMapper

class StyleClassMap: Mappable {
    var name : String?
    var propertyToModifie : String?
    var properties: [Property]?
    var styles : [String] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name    <- map["styleClass"]
        properties <- map["properties"]
        styles <- map["styles"]
    }
    
    func getProperty() -> String {
        return ""
    }
}

class Property : Mappable {
    var propertyName : String?
    var propertySetName : String?
    var propertyType: String?
    var propertyValue : JSONStyleProperty?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        propertyName    <- map["propertyName"]
        propertySetName <- map["propertySetName"]
        propertyType <- map["propertyType"]

        let check:(Any?, String) -> (Any?, JSONStyleProperty?) = {testValue, type in
            guard testValue != nil else {
                return (nil, .InvalidProperty(errorMessage: String(format:"'propertyValue' in JSON was missing or could not be converted to %@", type)))
            }
            return (testValue, nil)
        }
        
        var value: Any?
        value <- map["propertyValue"]

        if let type = propertyType, let value = value {
            if self.mapPrimitives(type: type, value: value, checkClosure: check) { return }
            if self.mapObjects(type: type, value: value, checkClosure: check) { return }
            if self.mapEnums(type: type, value: value, checkClosure: check) { return }
            
            self.propertyValue = .InvalidProperty(errorMessage: "Missing 'propertyValue' check data value types")
        }
    }
    
    func mapPrimitives(type: String, value: Any, checkClosure:(Any?, String) -> (Any?, JSONStyleProperty?)) -> Bool {
        switch type {
        case _ where type.isVariant(of: "CG Float") :
            let tuple = checkClosure(value as? CGFloat, type)
            self.propertyValue = (tuple.0 != nil) ? .CGFloatProperty(value: tuple.0 as! CGFloat) : tuple.1!
            break
        case _ where type.isVariant(of: "Float") :
            let tuple = checkClosure(value as? Float, type)
            self.propertyValue = (tuple.0 != nil) ? .FloatProperty(value: tuple.0 as! Float) : tuple.1!
            break
        case _ where type.isVariant(of: "Double") :
            let tuple = checkClosure(value as? Double, type)
            self.propertyValue = (tuple.0 != nil) ? .DoubleProperty(value: tuple.0 as! Double) : tuple.1!
            break
        case _ where type.isVariant(of: "Int") :
            let tuple = checkClosure(value as? Int, type)
            self.propertyValue = (tuple.0 != nil) ? .IntProperty(value: tuple.0 as! Int) : tuple.1!
            break
        case _ where type.isVariant(of: "Bool") :
            let tuple = checkClosure(value as? Bool, type)
            self.propertyValue = (tuple.0 != nil) ? .BoolProperty(value: tuple.0 as! Bool) : tuple.1!
            break
        case _ where type.isVariant(of: "CGColor") :
            let tuple = checkClosure(value as? String, value as! String)
            if tuple.0 != nil, let value = UIColor(hexString:(tuple.0 as! String))?.cgColor {
                self.propertyValue = .CGColorProperty(value: value)
            } else {
                self.propertyValue = tuple.1!
            }
            break
//        case _ where type.isVariant(of: "UI Edge Insets") || type.isVariant(of: "Edge Insets"):
//            guard let top = (value["top"] as? NSNumber)?.floatValue,
//                let left = (value["left"] as? NSNumber)?.floatValue,
//                let bottom = (value["bottom"] as? NSNumber)?.floatValue,
//                let right = (value["right"] as? NSNumber)?.floatValue else {
//                    self.propertyValue = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain values for 'top', 'left', 'bottom', and 'right' that could be converted to Floats")
//                    return true
//            }
//            let tuple = checkClosure(UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right)) as UIEdgeInsets, type)
//            self.propertyValue = (tuple.0 != nil) ? .UIEdgeInsetsProperty(value: tuple.0 as! UIEdgeInsets) : tuple.1!
//            break
//            
        default:
            return false;
        }
        
        return true
    }
    
    func mapObjects(type: String, value: Any, checkClosure:(Any?, String) -> (Any?, JSONStyleProperty?)) -> Bool {
        guard let type: AnyClass = NSClassFromString(type) else {
            self.propertyValue = .InvalidProperty(errorMessage: "Invalid 'propertyType' in JSON - check NSObject types")
            return false
        }
        
        switch type {
        case is String.Type:
            let tuple = checkClosure(value as? String, value as! String)
            self.propertyValue = (tuple.0 != nil) ? .StringProperty(value: tuple.0 as! String) : tuple.1!
            break
        case is UIColor.Type:
            let tuple = checkClosure(value as? String, value as! String)
            if tuple.0 != nil, let value = UIColor(hexString:(tuple.0 as! String)) {
                self.propertyValue = .UIColorProperty(value: value)
            } else {
                self.propertyValue = tuple.1!
            }
            break
        case is UIImage.Type:
            let tuple = checkClosure(value as? String, value as! String)
            if tuple.0 != nil, let value = UIImage(named: tuple.0 as! String) {
                self.propertyValue = .UIImageProperty(value: value)
            } else {
                self.propertyValue = tuple.1!
            }
            break
        case is UIFont.Type:
            if let dict = value as? NSDictionary {
                let fontName: String? = dict.value(forKey: "fontName") as? String
                let fontWeight: String? = dict["weight"] as? String
                let fontSize: Float? = dict.value(forKey: "pointSize") as? Float
                let font = UIFont.SimplifiedFont(name: fontName, weight: fontWeight, size: fontSize)
                
                self.propertyValue = .UIFontProperty(value: font)
            }
            break
        default:
            return false
        }
        
        return true
    }
    
    func mapEnums(type: String, value: Any, checkClosure:(Any?, String) -> (Any?, JSONStyleProperty?)) -> Bool {
        switch type {
        case _ where type.isVariant(of: "NSTextAlignment") || type.isVariant(of: "Text Alignment") :
            let tuple = checkClosure(value as? String, type)
            let value: String = (tuple.0 != nil) ? tuple.0 as! String : ""
            
            switch value {
            case _ where value.isVariant(of: "Left") :
                self.propertyValue = .NSTextAlignmentProperty(value: .left)
            case _ where value.isVariant(of: "Center") :
                self.propertyValue = .NSTextAlignmentProperty(value: .center)
            case _ where value.isVariant(of: "Right") :
                self.propertyValue = .NSTextAlignmentProperty(value: .right)
            case _ where value.isVariant(of: "Justified") :
                self.propertyValue = .NSTextAlignmentProperty(value: .justified)
            case _ where value.isVariant(of: "Natural") :
                self.propertyValue = .NSTextAlignmentProperty(value: .natural)
            default :
                self.propertyValue = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for an NSTextAlignment property, i.e. 'Left', 'Center', 'Right', 'Justified', 'Natural'")
            }
            break
            
        case _ where type.isVariant(of: "UITextBorderStyle") || type.isVariant(of: "Text Border Style"):
            let tuple = checkClosure(value as? String, type)
            let value: String = (tuple.0 != nil) ? tuple.0 as! String : ""
            
            switch value {
            case _ where value.isVariant(of: "bezel"):
                self.propertyValue = .UITextBorderStyleProperty(value: .bezel)
            case _ where value.isVariant(of: "line"):
                self.propertyValue = .UITextBorderStyleProperty(value: .line)
            case _ where value.isVariant(of: "none"):
                self.propertyValue = .UITextBorderStyleProperty(value: .none)
            case _ where value.isVariant(of: "roundedRect"):
                self.propertyValue = .UITextBorderStyleProperty(value: .roundedRect)
            default :
                self.propertyValue = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for an UITextBorderStyle property, i.e. 'bezel', 'line', 'none', 'roundedRect'")
            }
            break
            
        case _ where type.isVariant(of: "UI View Content Mode") || type.isVariant(of: "View Content Mode") || type.isVariant(of: "Content Mode") :
            let tuple = checkClosure(value as? String, type)
            let value: String = (tuple.0 != nil) ? tuple.0 as! String : ""
            
            switch value {
            case _ where value.isVariant(of: "Scale To Fill") :
                self.propertyValue = .UIViewContentModeProperty(value: .scaleToFill)
            case _ where value.isVariant(of: "Scale Aspect Fit") :
                self.propertyValue = .UIViewContentModeProperty(value: .scaleAspectFit)
            case _ where value.isVariant(of: "Scale Aspect Fill") :
                self.propertyValue = .UIViewContentModeProperty(value: .scaleAspectFill)
            case _ where value.isVariant(of: "Redraw") :
                self.propertyValue = .UIViewContentModeProperty(value: .redraw)
            case _ where value.isVariant(of: "Center") :
                self.propertyValue = .UIViewContentModeProperty(value: .center)
            case _ where value.isVariant(of: "Top") :
                self.propertyValue = .UIViewContentModeProperty(value: .top)
            case _ where value.isVariant(of: "Bottom") :
                self.propertyValue = .UIViewContentModeProperty(value: .bottom)
            case _ where value.isVariant(of: "Left") :
                self.propertyValue = .UIViewContentModeProperty(value: .left)
            case _ where value.isVariant(of: "Right") :
                self.propertyValue = .UIViewContentModeProperty(value: .right)
            case _ where value.isVariant(of: "Top Left") :
                self.propertyValue = .UIViewContentModeProperty(value: .topLeft)
            case _ where value.isVariant(of: "Top Right") :
                self.propertyValue = .UIViewContentModeProperty(value: .topRight)
            case _ where value.isVariant(of: "Bottom Left") :
                self.propertyValue = .UIViewContentModeProperty(value: .bottomLeft)
            case _ where value.isVariant(of: "Bottom Right") :
                self.propertyValue = .UIViewContentModeProperty(value: .bottomRight)
            default :
                self.propertyValue = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for a UIViewContentMode property, e.g. 'scaleToFill', 'scaleAspectFit', 'Center', 'topRight', etc.")
            }
            break
        default:
            return false
        }
        
        return true
    }
}
