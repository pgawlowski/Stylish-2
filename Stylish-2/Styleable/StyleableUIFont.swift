//
//  StyleableUIFont.swift
//  Stylish-2
//
//  Created by Piotr Gawlowski on 25/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

struct UIFontPropertySet : DynamicStylePropertySet {
    var propertySet: Dictionary<String, Any> = UIFont().retriveDynamicPropertySet()
    var fontWeight: String?
    
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariant(of: "font"):
            if let value = value as? UIFont.SimplifiedFont {
                self.propertySet["fontName"] = ((value.fontName) != nil) ? value.fontName! : NSNull()
                self.fontWeight = (value.fontWeight != nil) ? value.fontWeight : ""
                
                if let fontSize = value.fontSize, fontSize != 0 {
                    self.propertySet["pointSize"] = fontSize
                }
            }
            
        default :
            return
        }
    }
}

extension StyleClass {
//    var UIFont:UIFontPropertySet { get { return self.retrieve(propertySet: UIFontPropertySet.self) } set { self.register(propertySet: newValue) } }
}

 public class StyleableUIFont : UIFont, Styleable {
    
    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UIFontPropertySet : {
            (property:Property, target:Any) in
            
            var targetFont: UIFont?
            switch target {
            case let target as UITextField:
                targetFont = target.font
                break
            case let target as UILabel:
                targetFont = target.font
                break
            case let target as UIButton:
                targetFont = target.titleLabel?.font
                break
            default:
                break
            }
            
            if let targetFont = targetFont, let propertySet = property.propertyValue, let font = propertySet.value as? SimplifiedFont {
                
                var fontName: String = (font.fontName != nil) ? targetFont.fontName : font.fontName!
                let fontSize = (font.fontSize != nil) ? targetFont.pointSize : font.fontSize
                let fontWeight: String = (font.fontWeight != nil) ? font.fontWeight! : ""

                if !fontWeight.isEmpty {
                    if let dashRange = fontName.range(of: "-") {
                        fontName.removeSubrange(dashRange.lowerBound..<(fontName.endIndex))
                    }
                    fontName = (fontName.range(of: fontWeight) == nil) ? fontName + "-" + fontWeight : fontName
                }
                
                if let font = UIFont(name: fontName, size: fontSize!) {
                    if let target = target as? UITextField {
                        target.font = font
                    }
                    else if let target = target as? UILabel {
                        target.font = font
                    }
                    else if let target = target as? UIButton {
                        target.titleLabel?.font = font
                    }
                }
            }
        }]
    }

//
//    class var StyleApplicators: [StyleApplicator] {
//        return []
////        return [{
////            (style:StyleClass, target:Any) in
////
////            var targetFont: UIFont?
////
////            if let target = target as? UITextField {
////                targetFont = target.font!
////            }
////            else if let target = target as? UILabel {
////                targetFont = target.font
////            }
////            else if let target = target as? UIButton {
////                targetFont = (target.titleLabel?.font)!
////            }
////            
////            if targetFont != nil {
////                var fontName: String = (style.UIFont.propertySet["fontName"] is NSNull) ? targetFont!.fontName : style.UIFont.propertySet["fontName"] as! String
////                let fontWeight: String = (style.UIFont.fontWeight != nil) ? style.UIFont.fontWeight! : ""
////                let fontSize = (style.UIFont.propertySet["pointSize"] is NSNull) ? targetFont?.pointSize : style.UIFont.propertySet["pointSize"] as? CGFloat
////                
////                if !fontWeight.isEmpty {
////                    if let dashRange = fontName.range(of: "-") {
////                        fontName.removeSubrange(dashRange.lowerBound..<(fontName.endIndex))
////                    }
////                    fontName = (fontName.range(of: fontWeight) == nil) ? fontName + "-" + fontWeight : fontName
////                }
////                
////                if let font = UIFont(name: fontName, size: fontSize!) {
////                    if let target = target as? UITextField {
////                        target.font = font
////                    }
////                    else if let target = target as? UILabel {
////                        target.font = font
////                    }
////                    else if let target = target as? UIButton {
////                        target.titleLabel?.font = font
////                    }
////                }
////            }
////            }]
//    }
//    
    class func fontStyleApplicator(font: UIFont, value: UIFont.SimplifiedFont?) -> UIFont {
        if let fontValue = value {
            return fontValue.createFont(font)
        }
        return font
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
        }
    }
    
    override public func prepareForInterfaceBuilder() {
    }
}
