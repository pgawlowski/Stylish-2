//
//  UILabelPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

private var _styles: String = ""
@IBDesignable public class StyleableUILabel : UILabel {}

extension UILabel : Styleable {
    
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
        return [.UILabelPropertySet : {
            (property:Property, target:Any) in
            if let key = property.propertyName, let propertyValue = property.propertyValue  {
                switch target {
                case let label as UILabel:
                    label.setStyleProperties(value: propertyValue.rawValue, key: key)
                    break
                case let button as UIButton:
                    self.setProperties(target: button, propertyValue, key)
                    break
                default:
                    break
                }
            }
        }]
    }
    
    func setProperties(target: UIButton, _ property: JSONStyleProperty, _ key: String) {
        switch key {
        case "textColor":
            target.setTitleColor(property.rawValue as? UIColor, for: .normal)
            break
        default:
            target.titleLabel?.setStyleProperties(value: property.rawValue, key: key)
            break
        }
    }
}
