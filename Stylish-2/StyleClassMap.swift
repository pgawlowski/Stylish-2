//
//  StyleClass.swift
//  Styling App
//
//  Created by Michal Niemiec on 08/06/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import EVReflection

public class StyleClassMap: EVObject {
    var styleClass : String = ""
    var styles = [String]()
    var properties = [Property]()
    
    public override func setValue(_ value: Any!, forUndefinedKey key: String) {
        print(key, " " ,value)
    }
}

public class Property: EVObject {
    var propertyName : String?
    var propertySetName : String?
    var propertyType: String?
    var propertyValue : JSONStyleProperty?
    
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
    
    public func toDictionary(_ conversionOptions: ConversionOptions) -> NSDictionary {
        let dict = super.toDictionary()
        dict.setValue(self.propertyValue!.dictionaryValue, forKey: "propertyValue")

        return dict
    }
}

public class SimplifiedFont: EVObject {
    var fontName: String?
    var weight: String?
    var pointSize: NSNumber?
        
    func createFont(_ baseFont: UIFont) -> UIFont {
        let currentFont = baseFont
        
        var fontName = ((self.fontName) != nil) ? self.fontName : currentFont.fontName
        if let _ = self.weight {
            if let dashRange = fontName?.range(of: "-") {
                fontName?.removeSubrange(dashRange.lowerBound..<(fontName?.endIndex)!)
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
    
    public override func setValue(_ value: Any!, forUndefinedKey key: String) {
        print(key, " " ,value)
    }
}
