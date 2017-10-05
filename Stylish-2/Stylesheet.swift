//
//  Stylesheet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 05/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit
import EVReflection

let STYLE_FILE = "stylesheet"
let STYLE_EXTENSION = "json"

public class JSONStylesheet: NSObject {
    public var stylesheet = [StyleClassMap]()

    var filePath: URL?
    
    override init() {
        super.init()
        self.loadData()
        
        return
    }
    
    public func loadData() {
        var jsonPath: String?
        let bundle = Bundle.main

        #if TARGET_INTERFACE_BUILDER
            let processInfo = ProcessInfo.processInfo
            let environment = processInfo.environment
            let projectSourceDirectories = environment["IB_PROJECT_SOURCE_DIRECTORIES"]! as NSString
            let directories = projectSourceDirectories.components(separatedBy: ":")
            
            if directories.count != 0 {
                var firstPath = directories[0] as NSString
                firstPath = firstPath.deletingLastPathComponent as NSString
                jsonPath = firstPath.appendingPathComponent("stylesheet.json")
            }
        #else
            if let path = self.filePath {
                jsonPath = path.absoluteString
            } else {
                jsonPath = bundle.path(forResource: "stylesheet", ofType: "json")
            }
        #endif
        
        let path = URL(fileURLWithPath: jsonPath!)
        if let data = try? Data(contentsOf: path) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [[String : AnyObject]]
                if isValid(json!) {
                    parseJsonArrayToModel(json!)
                }
            } catch let error {
                assert(false, error.localizedDescription)
            }
        }
    }

    private func parseJsonArrayToModel(_ array: [[String:Any]]) {
        self.stylesheet = [StyleClassMap]()
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: array,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            
            EVReflection.setBundleIdentifier(StyleClassMap.self)
            EVReflection.setBundleIdentifier(Property.self)
            EVReflection.setBundleIdentifier(SimplifiedFont.self)

            self.stylesheet = EVReflection.arrayFromJson(type: StyleClassMap(), json: theJSONText) as [StyleClassMap]
        }
    }
    
    private func isValid(_ json:[[String : Any]]) -> Bool {
        for dictionary in json {
            guard let _ = dictionary["styleClass"] as? String else {
                assert(false, "Error in JSON stylesheet, possibly missing a 'styleClass' String value, or a 'properties' array for one of the included style classes")
                
                return false
            }
        }

        return true
    }
}
