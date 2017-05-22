//
//  UIButtonPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

// MARK: UIButton

struct UIButtonPropertySet : DynamicStylePropertySet {
    var propertySet: Dictionary<String, Any> = UIButton().retriveDynamicPropertySet()
}

extension StyleClass {
    var UIButton:UIButtonPropertySet { get { return self.retrieve(propertySet: UIButtonPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable class StyleableUIButton : UIButton, Styleable {
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + StyleableUILabel.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let button = target as? UIButton {
                for (key, value) in style.UIButton.propertySet {
                    if !(value is NSNull) {
                        button.setStyleProperties(value: value, key: key)
                    }
                }
            }
        }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
}
