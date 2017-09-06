//
//  StyleClass.swift
//  Styling App
//
//  Created by Michal Niemiec on 08/06/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import Foundation
import EVReflection

public class StyleClassMap: EVObject {
    var styleClass : String?
    var styles = [String]()
    var properties = [Property]()
}

public class Property: EVObject {
    var propertyName : String?
    var propertySetName : String?
    var propertyType: String?
    private var propertyValue : Any?

    var value: JSONStyleProperty? {
        get {
            return JSONStyleProperty.init(map: (self.propertyValue as? [String : Any])!)
        }
    }
}

//    override public func setValue(_ value: Any?, forKey key: String) {
//        if "propertyValue" == key {
//            self.propertyValue = JSONStyleProperty.init(map: value as! [String : Any])
//        } else {
//            super.setValue(value, forKey: key)
//        }
//    }

//    init(dictionary: NSDictionary) {
//        self = JSONStyleProperty(map: dictionary as! [String : Any])
//    }
    
//    public required init(dictionary:Dictionary<String, AnyObject?>) {
//        print("testt")
//    }
//    
//    required public init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    required public init() {
//        fatalError("init() has not been implemented")
//    }
    
//    required public init(map: [String : Any]) {
//        self.propertyValue = JSONStyleProperty(map: map)
//
//        propertyName = map["propertyName"] as? String
//        propertySetName = map["propertySetName"] as? String
//        propertyType = map["propertyType"] as? String
//    }
    
//    func toDictionary() -> Dictionary<String, String> {
//        var dict = [String:String]()
//
//        dict["propertyName"] = self.propertyName
//        dict["propertySetName"] = self.propertySetName
//        dict["propertyType"] = self.propertyType
//        dict["propertyValue"] =
//
//        return dict
//    }
