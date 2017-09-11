//
//  Property.swift
//  Pods
//
//  Created by Piotr Gawlowski on 06/09/2017.
//
//

import EVReflection

public class Property: EVObject {
    var propertyName : String = ""
    var propertySetName : String = ""
    var propertyType: String = ""
    private var propertyValue : String?
    
    var value: JSONStyleProperty? {
        get {
            return JSONStyleProperty.init(map: (self.propertyValue as? [String : Any])!)
        }
    }
}
