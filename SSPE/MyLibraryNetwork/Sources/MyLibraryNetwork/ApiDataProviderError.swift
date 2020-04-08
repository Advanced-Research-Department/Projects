//
//  ApiDataProviderError.swift
//  Livescore
//
//  Created by Alper on 03/04/2019.
//  Copyright © 2019 Livescore. All rights reserved.
//

import Foundation

enum ApiDataProviderFailureReason: Error {
    case invalidUrl
    case invalidJson
    case invalidResponse(description: String)
    case decryptionError
    case parsingError
    case cancelled
    case timeout
    case undefined
    
    //Could be changed due to requirements. Currently some errors don't have specific status codes!
    var statusCode: Int {
        switch self {
        case .invalidUrl:
            return 999999
        case .invalidJson:
            return 9997
        case .decryptionError:
            return 9998
        case .parsingError:
            return 9996
        case .timeout:
            return -1001
        default:
            return -1111
        }
    }
}


