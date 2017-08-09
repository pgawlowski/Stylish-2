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
    var stylesheet = [StyleClassMap]()
    static var cachedJson = [[String : AnyObject]]()

    var filePath: String?
    
    override init() {
        super.init()
        self.loadData()
        
        return
    }
    
    public func loadData() {
        var jsonPath: String?
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let savedDirectory = paths[0]
        let filename = savedDirectory.appending("/stylesheet.json")
        
        let bundle = Bundle.main
        let fileManager = FileManager.default
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
                jsonPath = path
            } else {
                jsonPath = bundle.path(forResource: "stylesheet", ofType: "json")
            }
        #endif
        
        // Compare the file modification date of the downloaded / copied version of stylesheet.json in the Documents directory, and the original version of stylesheet.json included in the app bundle. If the Documents version is more recent, load and parse that version.  Otherwise, use the bundle version and then copy it to the Documents directory.
        if let savedAttributes = try? fileManager.attributesOfItem(atPath: filename),
            let savedDate = savedAttributes[FileAttributeKey.modificationDate] as? NSDate, let path = jsonPath,
            let bundledAttributes = try? fileManager.attributesOfItem(atPath: path),
            let bundledDate = bundledAttributes[FileAttributeKey.modificationDate] as? NSDate  {
            
            if let data = NSData(contentsOfFile:filename), let json = (try? JSONSerialization.jsonObject(with: data as Data, options:[])) as? [[String : AnyObject]], savedDate.timeIntervalSinceReferenceDate >= bundledDate.timeIntervalSinceReferenceDate {
                
                JSONStylesheet.cachedJson = json
                if isValid(json) {
                    parseJsonArrayToModel(json)
                }
            } else if let path = jsonPath, let data = NSData(contentsOfFile:path), let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
                if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                    do {
                        try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                    }
                    catch {}
                }
                
                JSONStylesheet.cachedJson = json
                if isValid(json) {
                    parseJsonArrayToModel(json)
                }
            }
        }
        else if let path = URL.init(string: jsonPath!),
            let data = NSData(contentsOf: path),
            let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                do {
                    try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                }
                catch {}
            }
            
            JSONStylesheet.cachedJson = json
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
