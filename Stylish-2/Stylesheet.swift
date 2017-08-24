//
//  Stylesheet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 05/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

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
        
        if let path = URL.init(string: jsonPath!),
            let data = NSData(contentsOf: path),
            let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            if isValid(json) {
                parseJsonArrayToModel(json)
            }
        }
    }
    
    private func parseJsonArrayToModel(_ array: [[String:Any]]){
        self.stylesheet = [StyleClassMap]()
        for element in array {
            self.stylesheet.append(StyleClassMap(map: element))
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
