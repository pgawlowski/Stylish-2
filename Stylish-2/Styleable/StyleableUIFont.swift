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
            if let font = target as? UIFont {
                for (key, value) in style.UIFont.propertySet {
                    if !(value is NSNull) {
                        font.setStyleProperties(value: value, key: key)
                    }
                }
            }
            }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
//            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
//            parseAndApplyStyles()
        }
    }
    
    override func prepareForInterfaceBuilder() {
//        showErrorIfInvalidStyles()
    }
}
