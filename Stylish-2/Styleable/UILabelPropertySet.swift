//
//  UILabelPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

struct UILabelPropertySet : DynamicStylePropertySet {
    var propertySet: Dictionary<String, Any> = UILabel().retriveDynamicPropertySet()
}

extension StyleClass {
    var UILabel:UILabelPropertySet { get { return self.retrieve(propertySet: UILabelPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable class StyleableUILabel : UILabel, Styleable {

    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in

            switch target {
            case let label as UILabel:
                for (key, value) in style.UILabel.propertySet {
                    switch key {
                    case "font" where !(value is NSNull):
                        fontStyleApplicator(target: label, value: value as? UIFont.SimplifiedFont)
                        break
                    default:
                        label.setStyleProperties(value: value, key: key)
                    }
                }
                break
            case let button as UIButton:
                for (key, value) in style.UILabel.propertySet {
                    switch key as NSString {
                    case "textColor" where !(value is NSNull):
                        button.setTitleColor(value as? UIColor, for: .normal)
                        break
                    case "font" where !(value is NSNull):
                        fontStyleApplicator(target: button.titleLabel!, value: value as? UIFont.SimplifiedFont)
                        break
                    default:
                        button.titleLabel?.setStyleProperties(value: value, key: key)
                        break
                    }
                }
                break
            default:
                return
            }
        }]
    }

    class func fontStyleApplicator(target: UILabel, value: UIFont.SimplifiedFont?) {
        var font: UIFont = target.font
        if let fontValue = value {
            font = fontValue.createFont(font)
        }
        target.font = font
    }
    
    override func didMoveToSuperview() {
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
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
