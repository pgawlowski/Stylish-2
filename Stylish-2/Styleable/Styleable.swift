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
    static var StyleApplicator:[StyleApplicatorType : StyleApplicator] { get }
    var styles:String { get set }
}

extension Styleable {
    static var StyleApplicators:[StyleApplicatorType : StyleApplicator] {
        return StyleableUIButton.StyleApplicator + StyleableUIFont.StyleApplicator + StyleableUIImageView.StyleApplicator + StyleableUILabel.StyleApplicator + StyleableUITextField.StyleApplicator + StyleableUIView.StyleApplicator
    }
    
    func apply(style:StyleClassMap) {
        for property in style.properties {
            if let propertySetName = property.propertySetName, let applicator = Self.StyleApplicators[StyleApplicatorType(rawValue:propertySetName)!], let propertyValue = property.propertyValue {
                switch propertyValue {
                case .InvalidProperty:
                    assert(false, "The '\(String(describing: property.propertyName))' property in '\(String(describing: property.propertySetName))' for the style class '\(String(describing: style.name))' has the following error: \(String(describing: property.propertyValue?.value))")
                    break
                default:
                    applicator(property, self)
                    break
                }
            }
        }
    }
}

extension Styleable where Self:UIView {
    func parseAndApplyStyles() {
        self.layoutIfNeeded()
        parseAndApply(styles: styles)
    }
    
    func parseAndApply(styles:String) {
        let stylish = StylishJSONStylesheet.sharedInstance
        let components = styles.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: " ,", with: ",").components(separatedBy:",")
        
        for string in components {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let style = stylish.stylesheet.filter({ $0.name == trimmed }).first {
                if style.styles.count > 0 {
                    self.parseMultipleStyles(style: style, map: stylish.stylesheet)
                } else {
                    self.apply(style: style)
                }
            } else {
                print("!!!! Missing style named `\(trimmed)` !!!!")
            }
        }
    }
    
    func parseMultipleStyles(style: StyleClassMap, map: [StyleClassMap]) {
        for styleType in style.styles {
            if let styleToApply = map.filter({ $0.name == styleType }).first {
                self.apply(style: styleToApply)
            } else {
                print("!!!! Missing style named `\(styleType)` !!!!")
                break
            }
        }
    }
    
    func showErrorIfInvalidStyles() {
        showErrorIfInvalid(styles: styles)
    }
    
    func showErrorIfInvalid(styles:String) {
        let components = styles.replacingOccurrences(of:", ", with: ",").replacingOccurrences(of:" ,", with: ",").components(separatedBy:",")
        
        var invalidStyle = false
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }
        
        let stylesheet = JSONStylesheet.cachedJson
        for string in components where string != "" {
//            if stylesheet[string] == nil {
//                invalidStyle = true
//            }
        }
        
        
        
//        if let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
////            let stylesheet = stylesheetType.init()
////            for string in components where string != "" {
////                if stylesheet[string] == nil {
////                    invalidStyle = true
////                }
////            }
//        }
//        else if let stylesheetType = Stylish.GlobalStylesheet {
////            let stylesheet = stylesheetType.init()
////            for string in components where string != "" {
////                if stylesheet[string] == nil {
////                    invalidStyle = true
////                }
////            }
//        }
//        else {
//            let stylesheetName = "StylishJSONStylesheet"
//            if let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
////                let stylesheet = stylesheetType.init()
////                for string in components where string != "" {
////                    if stylesheet[string] == nil {
////                        invalidStyle = true
////                    }
////                }
//            }
//            else {
//                invalidStyle = true
//            }
//        }
        if invalidStyle {
            let errorView = Stylish.ErrorView(frame: bounds)
            errorView.tag = Stylish.ErrorViewTag
            addSubview(errorView)
        }
    }
}
