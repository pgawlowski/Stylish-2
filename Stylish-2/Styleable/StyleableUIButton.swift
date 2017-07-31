//
//  UIButtonPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class StyleableUIButton : UIButton, Styleable {
    
    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UIButtonPropertySet : {
            (property:Property, target:Any) in
            if let button = target as? UIButton, let key = property.propertyName, let propertyValue = property.propertyValue  {
                    button.setStyleProperties(value: propertyValue.value, key: key)
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
    
    override public func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
}
