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
    var stylesheet:String { get set }
}

extension Styleable {
    static var StyleApplicators:[StyleApplicatorType : StyleApplicator] {
        return StyleableUIButton.StyleApplicator + StyleableUIFont.StyleApplicator + StyleableUIImageView.StyleApplicator + StyleableUILabel.StyleApplicator + StyleableUITextField.StyleApplicator + StyleableUIView.StyleApplicator
    }
    
    func apply(style:StyleClassMap) {
        if let properties = style.properties {
            for property in properties {
                if let applicator = Self.StyleApplicators[StyleApplicatorType(rawValue:property.propertySetName!)!] {
//                    switch property.propertyValue {
//                    case .InvalidProperty: break
//                        
//                    default:
//                        <#code#>
//                    }
//                    switch property.propertyValue {
//                    case .InvalidProperty:
//                        assert(false, "The '\(property.propertyName)' property in '\(property.propertySetName)' for the style class '\(style.name)' has the following error: \(property.propertyValue)")
//                        break
//                    default:
                        applicator(property, self)
//                        break
//                    }
                }
            }
        }
    }
}

extension Styleable where Self:UIView {
    func parseAndApplyStyles() {
        self.layoutIfNeeded()
        parseAndApply(styles: styles, usingStylesheet: stylesheet)
    }
    
    func parseAndApply(styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: " ,", with: ",").components(separatedBy:",")
        
        for string in components where string != "" {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if let style = JSONStylesheet.styles.first(where: { (map) -> Bool in
                return map.name == trimmed
            }) {
                var styleToApply = style
                for styleType in style.styles {
                    styleToApply = JSONStylesheet.styles.first(where: { (styleClass) -> Bool in
                        return styleClass.name! == styleType
                    })!
                }
                self.apply(style: styleToApply)
            } else {
                print("!!!! Missing style named `\(trimmed)` !!!!")
            }
        }
    }
    
    private func useCachedJSON(forStylesheetType:Stylesheet.Type) -> Bool {
        let jsonCacheDuration = 3.0
        let isJSON = forStylesheetType is JSONStylesheet.Type
        let cacheExists = JSONStylesheet.cachedStylesheet != nil
        let isCacheExpired = NSDate.timeIntervalSinceReferenceDate - JSONStylesheet.cacheTimestamp > jsonCacheDuration
        return isJSON && cacheExists && !isCacheExpired
    }
    
    func showErrorIfInvalidStyles() {
        showErrorIfInvalid(styles: styles, usingStylesheet: stylesheet)
    }
    
    func showErrorIfInvalid(styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of:", ", with: ",").replacingOccurrences(of:" ,", with: ",").components(separatedBy:",")
        
        var invalidStyle = false
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }
        
        if let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
//            let stylesheet = stylesheetType.init()
//            for string in components where string != "" {
//                if stylesheet[string] == nil {
//                    invalidStyle = true
//                }
//            }
        }
        else if let stylesheetType = Stylish.GlobalStylesheet {
//            let stylesheet = stylesheetType.init()
//            for string in components where string != "" {
//                if stylesheet[string] == nil {
//                    invalidStyle = true
//                }
//            }
        }
        else {
            let stylesheetName = "StylishJSONStylesheet"
            if let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
//                let stylesheet = stylesheetType.init()
//                for string in components where string != "" {
//                    if stylesheet[string] == nil {
//                        invalidStyle = true
//                    }
//                }
            }
            else {
                invalidStyle = true
            }
        }
        if invalidStyle {
            let errorView = Stylish.ErrorView(frame: bounds)
            errorView.tag = Stylish.ErrorViewTag
            addSubview(errorView)
        }
    }
}
