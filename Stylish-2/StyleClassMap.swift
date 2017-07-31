//
//  StyleClass.swift
//  Styling App
//
//  Created by Michal Niemiec on 08/06/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import UIKit

public class StyleClassMap {
    var name : String?
    var propertyToModifie : String?
    var properties = [Property]()
    var styles = [String]()
    
    required public init(map: [String: Any]) {
        self.name = map["styleClass"] as? String
        
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
    
    func getProperty() -> String {
        return ""
    }
}

class Property {
    var propertyName : String?
    var propertySetName : String?
    var propertyType: String?
    var propertyValue : JSONStyleProperty?
    
    required init(map: [String : Any]) {
        self.propertyValue = JSONStyleProperty(map: map)
        
        propertyName = map["propertyName"] as? String
        propertySetName = map["propertySetName"] as? String
        propertyType = map["propertyType"] as? String
    }
}
