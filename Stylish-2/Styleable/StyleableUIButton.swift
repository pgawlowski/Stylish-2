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
//            if let button = target as? UIButton, let key = property.propertyName, let propertyValue = property.value {
//                    button.setStyleProperties(value: propertyValue.value, key: key)
//            }
        }]
    }
    
    @IBInspectable public var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
}
