//
//  ApiRequest.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 18.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct BaseMatch {}

class ApiRequest {
    let url: URL
    let payload: HttpBodyConvertable?
    let payloadIds: NSSet?
    let ifModifiedSince: String?
    let options: DataLoadOptions
    let cachePeriod: TimeInterval?
    let filter: ((BaseMatch) -> Bool)?
    let usePost: Bool
    
    var ignoreCache: Bool {
        return options.contains(.IgnoreCache)
    }
    
    init(url: URL, payload: HttpBodyConvertable?, payloadIds: NSSet?, ifModifiedSince: String?, options: DataLoadOptions, cachePeriod: TimeInterval?, filter: ((BaseMatch) -> Bool)?, usePost: Bool) {
        self.url = url
        self.payload = payload
        self.payloadIds = payloadIds
        self.ifModifiedSince = ifModifiedSince
        self.options = options
        self.cachePeriod = cachePeriod
        self.filter = filter
        self.usePost = usePost
    }
    
    lazy var simpleHttpRequest: SimpleHttpRequest = SimpleHttpRequest(url: self.url, payload: self.payload, ifModifiedSince: self.ifModifiedSince)
    
    convenience init(url: URL, payload: HttpBodyConvertable?, payloadIds: NSSet?, ifModifiedSince: String?, options: DataLoadOptions, filter: ((BaseMatch) -> Bool)?, usePost: Bool) {
        self.init(url: url, payload: payload, payloadIds: payloadIds, ifModifiedSince: ifModifiedSince, options: options, cachePeriod: nil, filter: filter, usePost: usePost)
    }
    
    convenience init(url: URL, ifModifiedSince: String?, options: DataLoadOptions, filter: ((BaseMatch) -> Bool)?) {
        self.init(url: url, payload: nil, payloadIds: nil, ifModifiedSince: ifModifiedSince, options: options, cachePeriod: nil, filter: filter, usePost: false)
    }
    
    convenience init(url: URL, ifModifiedSince: String?, options: DataLoadOptions) {
        self.init(url: url, payload: nil, payloadIds: nil, ifModifiedSince: ifModifiedSince, options: options, cachePeriod: nil, filter: nil, usePost: false)
    }
    
    convenience init(url: URL, ifModifiedSince: String?) {
        self.init(url: url, payload: nil, payloadIds: nil, ifModifiedSince: ifModifiedSince, options: DataLoadOptions(), cachePeriod: nil, filter: nil, usePost: false)
    }
    
    convenience init(url: URL) {
        self.init(url: url, payload: nil, payloadIds: nil, ifModifiedSince: nil, options: DataLoadOptions(), cachePeriod: nil, filter: nil, usePost: false)
    }
    
    convenience init(url: URL, ifModifiedSince: String?, options: DataLoadOptions, cachePeriod: TimeInterval?) {
        self.init(url: url, payload: nil, payloadIds: nil, ifModifiedSince: ifModifiedSince, options: options, cachePeriod: cachePeriod, filter: nil, usePost: false)
    }
}
