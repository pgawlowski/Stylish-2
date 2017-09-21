//
//  UIImagePropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

private var _styles: String = ""
@IBDesignable public class StyleableUIImageView : UIImageView {}

extension UIImageView : Styleable {
    
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
        return [.UIImageViewPropertySet : {
            (property:Property, target:Any) in
            if let key = property.propertyName, let propertyValue = property.propertyValue {
                switch target {
                case let imageView as UIImageView:
                    imageView.setStyleProperties(value: propertyValue.rawValue, key: key)
                    break
                default:
                    break
                }
            }
        }]
    }
    
}
