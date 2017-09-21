//
//  StyleableUITextField.swift
//  Stylish-2
//
//  Created by Piotr Gawlowski on 22/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

private var _styles: String = ""
@IBDesignable public class StyleableUITextField: UITextField {}

extension UITextField : Styleable {

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
        return [.UITextFieldPropertySet : {
            (property:Property, target:Any) in
            if let textField = target as? UITextField, let key = property.propertyName, let propertyValue = property.propertyValue {
                textField.setStyleProperties(value: propertyValue.rawValue, key: key)
            }
        }]
    }
}
