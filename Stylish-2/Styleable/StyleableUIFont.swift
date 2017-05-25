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
}

extension StyleClass {
    var UIFont:UIFontPropertySet { get { return self.retrieve(propertySet: UIFontPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable class StyleableUIFont : UIFont, Styleable {
    class var StyleApplicators: [StyleApplicator] {
        return [{
            (style:StyleClass, target:Any) in
            for (_, value) in style.UIFont.propertySet {
                if !(value is NSNull) {
                    if let target = target as? UITextField {
                        target.font = fontStyleApplicator(font: target.font!, value: value as? UIFont.SimplifiedFont)
                    }
                    else if let target = target as? UILabel {
                        target.font = fontStyleApplicator(font: target.font!, value: value as? UIFont.SimplifiedFont)
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
