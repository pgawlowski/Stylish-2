//
//  UIViewPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable public class StyleableUIView : UIView, Styleable {
    
    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UIViewPropertySet : {
            (property:Property, target:Any) in
            
//            if let view = target as? UIView, let key = property.propertyName, let propertyValue = property.value {
//                view.setStyleProperties(value: propertyValue.value, key: key)
//            }
        }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApply(styles: self.styles)
        }
    }
}
