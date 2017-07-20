//
//  UILabelPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

public class StyleableUILabel : UILabel, Styleable {

    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UILabelPropertySet : {
            (property:Property, target:Any) in
            if let key = property.propertyName, let styleProperty = property.propertyValue {
                switch target {
                case let label as UILabel:
                    label.setStyleProperties(value: styleProperty.value, key: key)
                    break
                case let button as UIButton:
                    self.setProperties(target: button, styleProperty, key)
                    break
                default:
                    break
                }
            }
        }]
    }

    class func setProperties(target: UIButton, _ property: JSONStyleProperty, _ key: String) {
        switch key {
        case "textColor":
            target.setTitleColor(property.value as? UIColor, for: .normal)
            break
        default:
            target.titleLabel?.setStyleProperties(value: property.value, key: key)
            break
        }
    }
    
    override public func didMoveToSuperview() {
        NotificationCenter.default.addObserver(self, selector: #selector(StyleableUILabel.refreshFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        super.didMoveToSuperview()
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
    
    func refreshFont() {
        parseAndApplyStyles()
    }
    
    override public func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
