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

//Mark Styleable
typealias StyleApplicator = (StyleClass, Any)->()

protocol Styleable {
    static var StyleApplicators:[StyleApplicator] { get }
    var styles:String { get set }
    var stylesheet:String { get set }
}

extension Styleable {
    func apply(style:StyleClass) {
        for applicator in Self.StyleApplicators {
            applicator(style, self)
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
        
        if let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else if let stylesheetType = Stylish.GlobalStylesheet {
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else {
            if let info = Bundle.main.infoDictionary, let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
                let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
                for string in components where string != "" {
                    if let style = stylesheet[string] {
                        self.apply(style: style)
                    }
                }
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
            let stylesheet = stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else if let stylesheetType = Stylish.GlobalStylesheet {
            let stylesheet = stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else {
            if let info = Bundle.main.infoDictionary, let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
                let stylesheet = stylesheetType.init()
                for string in components where string != "" {
                    if stylesheet[string] == nil {
                        invalidStyle = true
                    }
                }
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
