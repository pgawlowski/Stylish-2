//
//  UILabelPropertySet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 08/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

//protocol StyleableUILabelProtcol {
//    var StyleApplicator: [StyleApplicatorType : StyleApplicator] {get}
//    func setProperties(target: UIButton, _ property: JSONStyleProperty, _ key: String)
//    //    var style: String {get}
//    //    var stylesheet:String {get}
////    func refreshFont()
//
//}

@IBDesignable
extension UILabel : Styleable {
    static var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
        return [.UILabelPropertySet : {
            (property:Property, target:Any) in
            if let key = property.propertyName, let propertyValue = property.propertyValue  {
                switch target {
                case let label as UILabel:
                    label.setStyleProperties(value: propertyValue.value, key: key)
                    break
                case let button as UIButton:
//                    self.setProperties(target: button, propertyValue, key)
                    break
                default:
                    break
                }
            }
            }]
    }
    
    func setProperties(target: UIButton, _ property: JSONStyleProperty, _ key: String) {
        switch key {
        case "textColor":
            target.setTitleColor(property.value as? UIColor, for: .normal)
            break
        default:
            target.titleLabel?.setStyleProperties(value: property.value, key: key)
            break
        }
    }
 
    @IBInspectable var styles: String {
        set (key) {
            parseAndApply(styles: key)
        }
        get {
            return ""
        }
    }
}

//@IBDesignable public class StyleableUILabel : UILabel, Styleable {
//
//    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
//        return [.UILabelPropertySet : {
//            (property:Property, target:Any) in
//            if let key = property.propertyName, let propertyValue = property.propertyValue  {
//                switch target {
//                case let label as UILabel:
//                    label.setStyleProperties(value: propertyValue.value, key: key)
//                    break
//                case let button as UIButton:
//                    self.setProperties(target: button, propertyValue, key)
//                    break
//                default:
//                    break
//                }
//            }
//            }]
//    }
//
//    class func setProperties(target: UIButton, _ property: JSONStyleProperty, _ key: String) {
//        switch key {
//        case "textColor":
//            target.setTitleColor(property.value as? UIColor, for: .normal)
//            break
//        default:
//            target.titleLabel?.setStyleProperties(value: property.value, key: key)
//            break
//        }
//    }
//
//    override public func didMoveToSuperview() {
//        NotificationCenter.default.addObserver(self, selector: #selector(StyleableUILabel.refreshFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
//        super.didMoveToSuperview()
//    }
//
//    @IBInspectable var styles:String = "" {
//        didSet {
//            parseAndApplyStyles()
//        }
//    }
//
//    @IBInspectable var stylesheet:String = "" {
//        didSet {
//            parseAndApplyStyles()
//        }
//    }
//
//    func refreshFont() {
//        parseAndApplyStyles()
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}



////
////  UILabelPropertySet.swift
////  Stylish-2.0
////
////  Created by Piotr Gawlowski on 08/05/2017.
////  Copyright © 2017 Piotr Gawlowski. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//@IBDesignable public class StyleableUILabel : UILabel, Styleable {
//
//    class var StyleApplicator: [StyleApplicatorType : StyleApplicator] {
//        return [.UILabelPropertySet : {
//            (property:Property, target:Any) in
////            if let key = property.propertyName, let propertyValue = property.value {
////                switch target {
////                case let label as UILabel:
////                    label.setStyleProperties(value: propertyValue.value, key: key)
////                    break
////                case let button as UIButton:
////                    self.setProperties(target: button, propertyValue, key)
////                    break
////                default:
////                    break
////                }
////            }
//        }]
//    }
//
//    class func setProperties(target: UIButton, _ property: JSONStyleProperty, _ key: String) {
//        switch key {
//        case "textColor":
//            target.setTitleColor(property.value as? UIColor, for: .normal)
//            break
//        default:
//            target.titleLabel?.setStyleProperties(value: property.value, key: key)
//            break
//        }
//    }
//    
//    override public func didMoveToSuperview() {
//        NotificationCenter.default.addObserver(self, selector: #selector(StyleableUILabel.refreshFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
//        super.didMoveToSuperview()
//    }
//    
//    @IBInspectable var styles:String = "" {
//        didSet {
//            parseAndApplyStyles()
//        }
//    }
//    
//    @IBInspectable var stylesheet:String = "" {
//        didSet {
//            parseAndApplyStyles()
//        }
//    }
//    
//    func refreshFont() {
//        parseAndApplyStyles()
//    }
//        
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
