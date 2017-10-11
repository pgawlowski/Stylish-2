//
//  UIButtonPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation

private var _styles: String = ""
@IBDesignable public class StyleableUIButton : UIButton {}

extension UIButton: Styleable {
    
    @IBInspectable override var styles: String {
        set (key) {
            _styles = key
            parseAndApply(styles: key)
        }
        get {
            return _styles
        }
    }
    
    var styleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UIButtonPropertySet : {
            (property:Property, target:Any) in
            if let button = target as? UIButton, let key = property.propertyName, let propertyValue = property.propertyValue {
                    button.setStyleProperties(value: propertyValue.rawValue, key: key)
            }
        }]
    }
}
