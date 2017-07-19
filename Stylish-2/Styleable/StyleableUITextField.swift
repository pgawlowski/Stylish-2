//
//  StyleableUITextField.swift
//  Stylish-2
//
//  Created by Piotr Gawlowski on 22/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

struct UITextFieldPropertySet : DynamicStylePropertySet {
    var propertySet: Dictionary<String, Any> = UITextField().retriveDynamicPropertySet()
}

extension StyleClass {
//    var UITextField:UITextFieldPropertySet { get { return self.retrieve(propertySet: UITextFieldPropertySet.self) } set { self.register(propertySet: newValue) } }
}

 public class StyleableUITextField: UITextField, Styleable {

    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UITextFieldPropertySet : {
            (property:Property, target:Any) in
            if let textField = target as? UITextField, let key = property.propertyName, let styleProperty = property.propertyValue {
                textField.setStyleProperties(value: styleProperty.value, key: key)
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
