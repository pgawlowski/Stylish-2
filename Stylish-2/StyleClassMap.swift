//
//  StyleClass.swift
//  Styling App
//
//  Created by Michal Niemiec on 08/06/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import EVReflection

public class StyleClassMap: EVObject {
    public var styleClass : String = ""
    public var styles = [String]()
    public var properties = [Property]()
    
    public override func setValue(_ value: Any!, forUndefinedKey key: String) {
        print(key, " " ,value)
    }
}

public class Property: EVObject {
    public var propertyName : String?
    public var propertySetName : String?
    public var propertyType: String?
    public var propertyValue : JSONStyleProperty?
    
    public override func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == "propertyValue" {
            self.propertyValue = StyleProperty().jsonStyleProperty(value: value, type: self.propertyType!)
        } else {
            print(key, " ", value)
        }
    }
    
    override public func initValidation(_ dict: NSDictionary) {
        self.propertyName = dict.value(forKey: "propertyName") as? String
        self.propertySetName = dict.value(forKey: "propertySetName") as? String
        self.propertyType = dict.value(forKey: "propertyType") as? String        
    }
    
    public override func value(forKey key: String) -> Any? {
        return super.value(forKey: key)
    }
    
    override public func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> ()), encodeConverter: (() -> Any?))] {
        return [
            ( // We want a custom converter for the field isGreat
                key: "propertyValue"
                // isGreat will be true if the json says 'Sure'
                , decodeConverter: {
                    self.propertyValue = StyleProperty().jsonStyleProperty(value: $0, type: self.propertyType!)
            }
                // The json will say 'Sure  if isGreat is true, otherwise it will say 'Nah'
                , encodeConverter: {
                    return self.propertyValue!.dictionaryValue
            })
        ]
    }
}

public class SimplifiedFont: EVObject {
    public var fontName: String?
    public var weight: String?
    public var pointSize: NSNumber?
        
    func createFont(_ baseFont: UIFont) -> UIFont {
        let currentFont = baseFont
        
        var fontName = ((self.fontName) != nil) ? self.fontName : currentFont.fontName
        if let _ = self.weight {
            if let dashRange = fontName?.range(of: "-"), let endIndex = fontName?.endIndex {
                fontName?.removeSubrange(dashRange.lowerBound..<endIndex)
            }
        }
        
        fontName = (self.weight != nil && fontName?.range(of: weight!) == nil) ? fontName! + "-" + self.weight! : fontName
        let fontSize = (self.pointSize != nil && self.pointSize != 0) ? CGFloat((self.pointSize?.floatValue)!) : currentFont.pointSize
        
        if let font = UIFont(name: fontName!, size: fontSize) {
            return font
        } else {
            print("!!!!StylishError!!!! Invalid font name \(String(describing: fontName))")
            return UIFont(name: "HelveticaNeue", size: 12)!
        }
    }
}
