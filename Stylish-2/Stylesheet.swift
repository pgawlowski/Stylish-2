//
//  Stylesheet.swift
//  Stylish-2.0
//
//  Created by Piotr Gawlowski on 05/05/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import Foundation
import UIKit

protocol Stylesheet : class {
    var styleClasses:[(identifier:String, styleClass:StyleClass)] { get }
    func style(named:String)->StyleClass?
}

extension Stylesheet {
    func style(named name: String) -> StyleClass? {
        for (identifier, styleClass) in styleClasses {
            if name.isVariant(of: identifier) {
                return styleClass
            }
        }
        return nil
    }
    
    subscript(styleName:String)->StyleClass? {
        get {
            return style(named: styleName)
        }
    }
}

let STYLE_FILE = "stylesheet"
let STYLE_EXTENSION = "json"

public class JSONStylesheet : Stylesheet {
    
    var filePath: String?
    static var styles = [StyleClassMap]()
    
    static var cachedStylesheet:JSONStylesheet?
    static var cacheTimestamp:TimeInterval = 0
    
    struct DynamicStyleClass : StyleClass {
        var stylePropertySets:StylePropertySetCollection
        init(jsonArray:[[String : AnyObject]], styleClass:String, dynamicPropertySets:[StylePropertySet.Type]? = nil) {
            stylePropertySets = StylePropertySetCollection(sets: dynamicPropertySets)
            for dictionary in jsonArray {
//                if let propertySetName = dictionary["propertySetName"] as? String, let property = dictionary["propertyName"] as? String {
//                    var style = JSONStyleProperty(dictionary: dictionary)
//                    style.mutate(dictionary:dictionary)
//                    switch style {
//                    case .InvalidProperty :
//                        assert(false, "The '\(property)' property in '\(propertySetName)' for the style class '\(styleClass)' has the following error: \(style.value)")
//                        break
//                    default :
//                        break
////                        var propertySet = retrieve(dynamicPropertySetName: propertySetName)
////                        propertySet?.setStyleProperty(named:property, toValue:style.value)
////                        if let modified = propertySet {
////                            register(propertySet: modified)
////                        }
//                    }
//                }
            }
        }
    }
    
    var styleClasses = [(identifier: String, styleClass: StyleClass)]()
//    var dynamicPropertySets:[StylePropertySet.Type] { get { return [UIViewPropertySet.self, UILabelPropertySet.self, UIButtonPropertySet.self, UITextFieldPropertySet.self, UIImageViewPropertySet.self, UIFontPropertySet.self] } }
    
    internal func setup() {
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
            jsonPath = bundle.path(forResource: "stylesheet", ofType: "json")
        #endif

        // Compare the file modification date of the downloaded / copied version of stylesheet.json in the Documents directory, and the original version of stylesheet.json included in the app bundle. If the Documents version is more recent, load and parse that version.  Otherwise, use the bundle version and then copy it to the Documents directory.
        
        if let savedAttributes = try? fileManager.attributesOfItem(atPath: filename), let savedDate = savedAttributes[FileAttributeKey.modificationDate] as? NSDate, let path = jsonPath, let bundledAttributes = try? fileManager.attributesOfItem(atPath: path), let bundledDate = bundledAttributes[FileAttributeKey.modificationDate] as? NSDate  {
            
            if let data = NSData(contentsOfFile:filename), let json = (try? JSONSerialization.jsonObject(with: data as Data, options:[])) as? [[String : AnyObject]], savedDate.timeIntervalSinceReferenceDate >= bundledDate.timeIntervalSinceReferenceDate {
//                parse(json: json)
                parseJsonArrayToModel(json)
            } else if let path = jsonPath, let data = NSData(contentsOfFile:path), let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
                if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                    do {
                        try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                    }
                    catch {}
                }
                
//                parse(json: json)
                parseJsonArrayToModel(json)
            }
        }
        else if let path = jsonPath, let data = NSData(contentsOfFile:path), let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                do {
                    try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                }
                catch {}
            }
//            parse(json: json)
            parseJsonArrayToModel(json)
        }
        
        return
    }
    
    private func parseJsonArrayToModel(_ array: [[String:Any]]){
        JSONStylesheet.styles = [StyleClassMap]()
        for element in array {
            JSONStylesheet.styles.append(StyleClassMap(JSON: element)!)
        }
    }
    
//    private func parse(json:[[String : AnyObject]]) {
//        for dictionary in json {
//            if let styleClass = dictionary["styleClass"] as? String,
//                let array = dictionary["styles"] as? [String] {
//                
//                var outputArray = [[String : AnyObject]]()
//                for style in array {
//                    let searchPredicate = NSPredicate(format: "styleClass MATCHES[c] %@", style)
//                    if let dict: Dictionary = (json as NSArray).filtered(using: searchPredicate).first as? [String : AnyObject],
//                        let arr = dict["properties"] as? [[String : AnyObject]] {
//                        outputArray += arr
//                    }
//                }
//                styleClasses.append((identifier: styleClass, styleClass: DynamicStyleClass(jsonArray: outputArray, styleClass:styleClass, dynamicPropertySets: dynamicPropertySets)))
//            } else if let styleClass = dictionary["styleClass"] as? String,
//                let array = dictionary["properties"] as? [[String : AnyObject]] {
//                styleClasses.append((identifier: styleClass, styleClass: DynamicStyleClass(jsonArray: array, styleClass:styleClass, dynamicPropertySets: dynamicPropertySets)))
//            } else {
//                assert(false, "Error in JSON stylesheet, possibly missing a 'styleClass' String value, or a 'properties' array for one of the included style classes")
//            }
//        }
//        JSONStylesheet.cacheTimestamp = NSDate.timeIntervalSinceReferenceDate
//        JSONStylesheet.cachedStylesheet = self
//    }
}
