//
//  StyleableUIFont.swift
//  Stylish-2
//
//  Created by Piotr Gawlowski on 25/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

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
                var fontName: String = (font.fontName != nil) ? font.fontName! : targetFont.fontName
                let fontSize = (font.fontSize != nil && font.fontSize != 0) ? font.fontSize : targetFont.pointSize
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
}
