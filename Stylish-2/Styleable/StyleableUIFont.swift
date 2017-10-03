//
//  StyleableUIFont.swift
//  Stylish-2
//
//  Created by Piotr Gawlowski on 25/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

extension UIFont: Styleable {
    var styles: String {
        return ""
    }
    
    var styleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UIFontPropertySet : {
            (property:Property, target:Any) in
            if let _ = property.propertyName,
                let propertyValue = property.propertyValue,
                let font = propertyValue.rawValue as? SimplifiedFont {
                
                switch target {
                case let textField as UITextField:
                    textField.font = font.createFont(textField.font!)
                    break
                case let label as UILabel:
                    label.font = font.createFont(label.font!)
                    break
                case let button as UIButton:
                    button.titleLabel?.font = font.createFont((button.titleLabel?.font)!)
                    break
                default:
                    break
                }
            }
        }]
    }
}
