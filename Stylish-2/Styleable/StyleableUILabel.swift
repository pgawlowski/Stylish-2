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

@IBDesignable public class StyleableUILabel : UILabel, Styleable {
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + StyleableUIFont.StyleApplicators + [{
            (style:StyleClass, target:Any) in

            switch target {
            case let label as UILabel:
                for (key, value) in style.UILabel.propertySet {
                    if !(value is NSNull) {
                        switch key {
                        default:
                            label.setStyleProperties(value: value, key: key)
                        }
                    }
                }
                break
            case let button as UIButton:
                for (key, value) in style.UILabel.propertySet {
                    if !(value is NSNull) {
                        switch key as NSString {
                        case "textColor" where !(value is NSNull):
                            button.setTitleColor(value as? UIColor, for: .normal)
                            break
                        default:
                            button.titleLabel?.setStyleProperties(value: value, key: key)
                            break
                        }
                    }
                }
                break
            default:
                return
            }
        }]
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
