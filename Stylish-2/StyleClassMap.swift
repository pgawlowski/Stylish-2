//
//  StyleClass.swift
//  Styling App
//
//  Created by Michal Niemiec on 08/06/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import UIKit
import ObjectMapper

class StyleClassMap: Mappable {
    var name : String?
    var propertyToModifie : String?
    var properties: [Property]?
    var styles : [String] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name    <- map["styleClass"]
        properties <- map["properties"]
        styles <- map["styles"]
    }
    
    func getProperty() -> String {
        return ""
    }
}

class Property : Mappable {
    var propertyName : String?
    var propertySetName : String?
    var propertyType: String?
    var propertyValue = JSONStyleProperty()

    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.propertyValue = JSONStyleProperty(map: map)
        
        propertyName    <- map["propertyName"]
        propertySetName <- map["propertySetName"]
        propertyType <- map["propertyType"]
    }
}
