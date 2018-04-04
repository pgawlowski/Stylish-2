//
//  Styleable.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 05/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

private class BundleMarker {}

enum StyleApplicatorType: String {
    case UIButtonPropertySet
    case UITextFieldPropertySet
    case UILabelPropertySet
    case UIViewPropertySet
    case UIFontPropertySet
    case UIImageViewPropertySet
}

//Mark Styleable
typealias StyleApplicator = (Property, Any)->()

protocol Styleable {
    var styleApplicator:[StyleApplicatorType : StyleApplicator] { get }
    var styles:String { get }
}

extension Styleable {
    var styleApplicator:[StyleApplicatorType : StyleApplicator] {
        
        var aplicator =  UILabel().styleApplicator
        aplicator = aplicator + UIButton().styleApplicator
        aplicator = aplicator + UITextField().styleApplicator
        aplicator = aplicator + UIImageView().styleApplicator
        aplicator = aplicator + UIFont().styleApplicator
        return aplicator + [.UIViewPropertySet : {
                (property:Property, target:Any) in
                if let view = target as? UIView, let key = property.propertyName, let propertyValue = property.propertyValue {
                    view.setStyleProperties(value: propertyValue.rawValue, key: key)
                }
            }]
    }
    
    public func apply(style:StyleClassMap) {
        for property in style.properties {
            if let propertySetName = property.propertySetName,
                let applicator = self.styleApplicator[StyleApplicatorType(rawValue:propertySetName)!],
                let propertyValue = property.propertyValue {
                switch propertyValue {
                case .InvalidProperty:
                    assert(false, "The '\(String(describing: property.propertyName))' property in '\(String(describing: property.propertySetName))' for the style class '\(String(describing: style.styleClass))' has the following error: \(String(describing: property.propertyValue?.rawValue))")
                    break
                default:
                    applicator(property, self)
                    break
                }
            }
        }
    }
    
    public func parseMultipleStyles(style: StyleClassMap, map: [StyleClassMap]) {
        for styleType in style.styles {
            if let styleToApply = map.filter({ $0.styleClass.lowercased() == styleType.lowercased() }).first {
                self.apply(style: styleToApply)
            } else {
                print("!!!!StylishError!!!! Missing style named `\(styleType)` !!!!")
                #if TARGET_INTERFACE_BUILDER
                    self.showErrorIfInvalid()
                #endif
                break
            }
        }
        self.apply(style: style)
    }
}

extension Styleable where Self:UIView {    
    func parseAndApply(styles:String) {
        self.layoutIfNeeded()

        let stylish = StylishJSONStylesheet.sharedInstance
        let components = styles.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: " ,", with: ",").components(separatedBy:",")
        
        for string in components {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let style = stylish.stylesheet.filter({ $0.styleClass.lowercased() == trimmed.lowercased() }).first {
                if style.styles.count > 0 {
                    self.parseMultipleStyles(style: style, map: stylish.stylesheet)
                } else {
                    self.apply(style: style)
                }
            } else {
                print("!!!!StylishError!!!! Missing style named `\(trimmed)` !!!!")
                #if TARGET_INTERFACE_BUILDER
                    self.showErrorIfInvalid()
                #endif
            }
        }
    }
    
    func showErrorIfInvalid() {
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }

        let errorView = Stylish.ErrorView(frame: bounds)
        errorView.tag = Stylish.ErrorViewTag
        addSubview(errorView)
    }
}
