//
//  UIImagePropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class StyleableUIImageView : UIImageView, Styleable {
    
    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UIImageViewPropertySet : {
            (property:Property, target:Any) in
            
//            if let key = property.propertyName, let propertyValue = property.value {
//                switch target {
//                case let imageView as UIImageView:
//                    imageView.setStyleProperties(value: propertyValue.value, key: key)
//                    break
//                default:
//                    break
//                }
//            }
        }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApply(styles: self.styles)
        }
    }    
}
