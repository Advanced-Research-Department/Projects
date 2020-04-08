//
//  LSApiResponse.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 18.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

protocol LSMBaseApiResponse {
    var lastModified: String? {get}
    var isNotModified: Bool {get}
    var error: Error? {get}
    var statusCode: Int? {get}
}

class LSMApiResponse: LSMBaseApiResponse {
    let data: Data?
    let lastModified: String?
    let isNotModified: Bool
    let error: Error?
    let statusCode: Int?
    
    init(data: Data?, lastModified: String?, isNotModified: Bool, error: Error?, statusCode: Int? = nil) {
        self.data = data
        self.lastModified = lastModified
        self.isNotModified = isNotModified
        self.error = error
        self.statusCode = statusCode
    }
    
    convenience init(data: Data?, simpleHttpResponse r: SimpleHttpResponse) {
        self.init(data: data, lastModified: r.lastModified, isNotModified: r.isNotModified, error: r.error, statusCode: r.statusCode)
    }
    
    convenience init(data: Data?, dataProviderResponse r: LSMBaseApiResponse) {
        self.init(data: data, lastModified: r.lastModified, isNotModified: r.isNotModified, error: r.error, statusCode: r.statusCode)
    }
    
    convenience init(customError: Error?,statusCode: Int?) {
        self.init(data: nil, lastModified: nil, isNotModified: false, error: customError, statusCode: statusCode)
    }
}
