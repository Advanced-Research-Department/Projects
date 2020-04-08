//
//  LSDataCache.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 18.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import UIKit

fileprivate struct LSMDataCacheRecord: Codable {
    let data: Data
    let date: Date
    let lastModified: String?
}

class LSMDataCache {
    static let sharedInstance = LSMDataCache()
    
    private var cache = [String: LSMDataCacheRecord]()
    
    private let cacheFilePath: String?
    
    init(cacheFileName: String) {
        if let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
            cacheFilePath = "\(path)/\(cacheFileName)"
        } else {
            cacheFilePath = nil
        }
    }
    
    convenience init() {
        self.init(cacheFileName: "cache-app-v4.json")
    }
    
    func setData(_ data: Data, lastModified: String? = nil, forKey key: String) {
        let date = Date()
        let item = LSMDataCacheRecord(data: data, date: date, lastModified: lastModified)
        cache[key] = item
    }
    
    func dataForKey(_ key: String) -> (data: Data, lastModified: String?)? {
        if let result = cache[key] {
            return (result.data, result.lastModified)
        }
        return nil
    }
    
    func dataWithDateForKey(_ key: String) -> (data: Data, lastModified: String?, date: Date)? {
        if let result = cache[key] {
            return (data: result.data, lastModified: result.lastModified, date: result.date)
        }
        return nil
    }
    
    func dataForKey(_ key: String, withExpiry expiry: Date) -> (data: Data, lastModified: String?)? {
        if let (data, lastModified, date) = dataWithDateForKey(key), date.compare(expiry) != ComparisonResult.orderedAscending {
            return (data: data, lastModified: lastModified)
        }
        return nil
    }
    
    func load() {
        guard let filePath = cacheFilePath else { return }
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: NSData.ReadingOptions.uncached)
                let decoder = JSONDecoder()
                cache = try decoder.decode([String: LSMDataCacheRecord].self, from: data)
            } catch {
                NSLog("failed load cache file:", error.localizedDescription)
            }
        } else {
            cache = [:]
        }
    }
    
    @discardableResult func save() -> Bool {
        if let p = cacheFilePath {
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(cache)
                try jsonData.write(to: URL(fileURLWithPath: p), options: [.atomic])
                return true
            }
            catch {
                NSLog("failed save cache file:", error.localizedDescription)
            }

        }
        return false
    }
    
    func clear() {
        cache.removeAll()
    }

}
