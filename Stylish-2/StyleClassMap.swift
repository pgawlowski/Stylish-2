//
//  StyleClass.swift
//  Styling App
//
//  Created by Michal Niemiec on 08/06/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import UIKit

public class StyleClassMap {
    public var name : String?
    public var propertyToModifie : String?
    public var properties = [Property]()
    public var styles = [String]()
    
    required public init(map: [String: Any]) {
        self.name = (map["styleClass"] as? String)
        
        if let propertiesArray = map["properties"] as? [NSDictionary] {
            for element in propertiesArray {
                if let element = element as? [String : Any] {
                    self.properties.append(Property(map: element))
                }
            }
        }
        
        if let styles = map["styles"] as? [String] {
            self.styles = styles
        }
    }
}

public class Property {
    public var propertyName : String?
    public var propertySetName : String?
    public var propertyType: String?
    public var propertyValue : JSONStyleProperty?

    required public init(map: [String : Any]) {
        self.propertyValue = JSONStyleProperty(map: map)
        
        propertyName = map["propertyName"] as? String
        propertySetName = map["propertySetName"] as? String
        propertyType = map["propertyType"] as? String
    }
}
