//
//  JSONParseUtil.swift
//  LiveScore v3
//
//  Created by Rosta on 19/04/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

import Foundation

struct JSONUtils {
    static func getStringFromJSON(_ json: NSDictionary, name: String) -> String? {
        return json.object(forKey: name) as? String
    }
    
    static func getForceStringFromJSON(_ json: NSDictionary, name: String) -> String? {
        if let r = json.object(forKey: name) as? String {
            return r
        } else if let i = json.object(forKey: name) as? NSNumber {
            return i.stringValue
        }
        return nil
    }
    
    static func getNumberFromJSON(_ json: NSDictionary, name: String, defaultVal: Int) -> Int {
        return self.getIntFromJSON(json, name: name, defaultVal: defaultVal)
    }
    
    static func getFloatFromJSON(_ json: NSDictionary, name: String) -> Float? {
        if let i = json.object(forKey: name) as? NSNumber {
            return i.floatValue
        }
        return nil
    }
    
    static func getFloatFromJSON(_ json: NSDictionary, name: String, defaultVal: Float) -> Float {
        return getFloatFromJSON(json, name: name) ?? defaultVal
    }
    
    static func getDoubleFromJSON(_ json: NSDictionary, name: String) -> Double? {
        if let i = json.object(forKey: name) as? NSNumber {
            return i.doubleValue
        }
        return nil
    }
    
    static func getDoubleFromJSON(_ json: NSDictionary, name: String, defaultVal: Double) -> Double {
        return getDoubleFromJSON(json, name: name) ?? defaultVal
    }
    
    static func getIntFromJSON(_ json: NSDictionary, name: String) -> Int? {
        if let i = json.object(forKey: name) as? NSNumber {
            return i.intValue
        }
        return nil
    }
    
    static func getIntFromJSON(_ json: NSDictionary, name: String, defaultVal: Int) -> Int {
        return getIntFromJSON(json, name: name) ?? defaultVal
    }
    
    static func getInt64FromJSON(_ json: NSDictionary, name: String) -> Int64? {
        if let i = json.object(forKey: name) as? NSNumber {
            return i.int64Value
        }
        return nil
    }
    
    static func getArrayFromJSON(_ json: NSDictionary, name: String) -> NSArray? {
        return json[name] as? NSArray
    }
    
    static func getStringArrayFromJSON(_ json: NSDictionary, name: String) -> [String]? {
        var result = [String]()
        if let a = json.object(forKey: name) as? NSArray {
            for item in a {
                guard let s = item as? String else {continue}
                result.append(s)
            }
        }
        return result.isEmpty ? nil : result
    }
    
    static func getDateStringFromJSON(_ json: NSDictionary, name: String) -> String? {
        if let n = json.object(forKey: name) as? NSNumber {
            return n.stringValue
        }
        else {
            return nil
        }
    }
    
    static func getBoolFromJSON(_ json: NSDictionary, name: String) -> Bool {
        let value = json.object(forKey: name)
        if let i = value as? NSNumber {
            return i.boolValue
        }
        else if let s = value as? String {
            return s == "true"
        }
        
        return false;
    }
    
//    static func parseModelArray<T: SimpleDataProcessingModel>(_ data: NSArray?) -> [T]? {
//        if data != nil {
//            var arr:[T] = [T]()
//            for i in 0..<data!.count {
//                if let sJson = data!.object(at: i) as? NSDictionary {
//                    let item:T = T(data: sJson)
//                    arr.append(item)
//                }
//            }
//            return arr
//        }
//        return nil
//    }
//    
//    static func parseDateArray(_ array: NSArray?) -> [Date] {
//        var dArr: [Date] = [Date]()
//        if let a = array, a.count > 0 {
//            for i in 0..<a.count {
//                guard let num = a[i] as? NSNumber, let date = DateUtil.sharedInstance.getDateTime(num.stringValue) else {continue}
//                dArr.append(date)
//            }
//        }
//        return dArr
//    }
}
