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
    
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariant(of: "font"):
            if let value = value as? UIFont.SimplifiedFont {
                let currentName = (!(self.propertySet["fontName"] is NSNull)) ? self.propertySet["fontName"] as! String : "HelveticaNeue"
                var fontName: String = ((value.fontName) != nil) ? value.fontName! : currentName

                if let fontWeight = value.fontWeight {
                    if let dashRange = fontName.range(of: "-") {
                        fontName.removeSubrange(dashRange.lowerBound..<(fontName.endIndex))
                    }
                    
                    fontName = (fontWeight != nil && fontName.range(of: fontWeight) == nil) ? fontName + "-" + fontWeight : fontName
                }
                self.propertySet["fontName"] = fontName
                
                
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
    var UIFont:UIFontPropertySet { get { return self.retrieve(propertySet: UIFontPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable class StyleableUIFont : UIFont, Styleable {
    class var StyleApplicators: [StyleApplicator] {
        return [{
            (style:StyleClass, target:Any) in
            
            let fontName = style.UIFont.propertySet["fontName"]
            let fontSize = style.UIFont.propertySet["pointSize"]
            
            if !(fontName is NSNull) && !(fontSize is NSNull) {                
                if let value = UIFont(name: fontName as! String, size: fontSize as! CGFloat) {
                    if let target = target as? UITextField {
                        target.font = value
                    }
                    else if let target = target as? UILabel {
                        target.font = value
                    }
                    else if let target = target as? UIButton, let targetFont = target.titleLabel?.font {
                        target.titleLabel?.font = value
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
    
    override func prepareForInterfaceBuilder() {
    }
}
