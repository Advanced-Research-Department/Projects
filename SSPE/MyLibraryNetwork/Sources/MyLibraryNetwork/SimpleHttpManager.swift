//
//  SimpleHttpManager.swift
//  LiveScore v3
//
//  Created by vaclav on 04/11/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

import Foundation

protocol HttpBodyConvertable {
    var httpBody: Data? { get }
}

class SimpleHttpRequest {
    struct Headers {
        static let IfModifiedSince = "If-Modified-Since"
    }
    
    struct Methods {
        static let GET = "GET"
        static let POST = "POST"
    }
    
    private static let timeout: TimeInterval = 30
    
    let ifModifiedSince: String?
    let isEphemeral: Bool
    let url: URL?
    
    private let payload: HttpBodyConvertable?
    
    init(url: URL?, payload: HttpBodyConvertable?, ifModifiedSince: String?, isEphemeral: Bool) {
        self.url = url
        self.payload = payload
        self.ifModifiedSince = ifModifiedSince
        self.isEphemeral = isEphemeral
    }
    
    convenience init(url: URL?, payload: HttpBodyConvertable?, ifModifiedSince: String?) {
        self.init(url: url, payload: payload, ifModifiedSince: ifModifiedSince, isEphemeral: false)
    }
    
    convenience init(url: URL?, ifModifiedSince: String?) {
        self.init(url: url, payload: nil, ifModifiedSince: ifModifiedSince, isEphemeral: false)
    }
    
    convenience init(url: URL?) {
        self.init(url: url, payload: nil, ifModifiedSince: nil, isEphemeral: false)
    }
    
    func urlRequest() -> URLRequest? {
        guard let requestUrl = url else { return nil }
        
        let cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        
        var urlRequest = URLRequest(url: requestUrl, cachePolicy: cachePolicy, timeoutInterval: SimpleHttpRequest.timeout)
        if let m = ifModifiedSince {
            urlRequest.addValue(m, forHTTPHeaderField: Headers.IfModifiedSince)
        }
        if let httpBody = payload?.httpBody {
            urlRequest.httpMethod = Methods.POST
            urlRequest.httpBody = httpBody
        }
        return urlRequest
    }
}

class SimpleHttpResponse {
    
    struct Headers {
        static let LastModified = "Last-Modified"
    }
    
    struct Errors {
        static let emptyData = NSError(domain: "Received empty data", code: 99999, userInfo: nil)
        static let invalidUrl = NSError(domain: "Invalid URL", code: 999, userInfo: nil)
    }
    
    static let invalidUrlResponse = SimpleHttpResponse(customError: Errors.invalidUrl)
    
    let data: Data?, lastModified: String?, isNotModified: Bool, error: Error?
    var statusCode: Int?, urlString: String?
    
    init(request: SimpleHttpRequest?, data: Data?, urlResponse: URLResponse?, error: Error?) {
        var isNotModified = false
        var lastModified: String?
        
        if let r = urlResponse as? HTTPURLResponse, error == nil {
            self.statusCode = r.statusCode
            if let urlString = request?.url?.absoluteString {
                self.urlString = urlString
//                Logger.shared.log(.simpleHttpManager, .error, "\(urlString) responded with code \(r.statusCode)")
            }
            isNotModified = r.statusCode == 304
            lastModified = r.allHeaderFields[Headers.LastModified] as? String ?? request?.ifModifiedSince
        }
        
        if ((data != nil || isNotModified) && error == nil) || error != nil {
            self.error = error
        } else {
            self.error = Errors.emptyData
        }
        
        self.data = data
        self.isNotModified = isNotModified
        self.lastModified = lastModified
    }
    
    convenience init(customError: Error) {
        self.init(request: nil, data: nil, urlResponse: nil, error: customError)
    }
}

class SimpleHttpManager {
    
    static let sharedInstance = SimpleHttpManager()
    
    private let session: URLSession
    private let ephemeralSession: URLSession
    
    init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
        ephemeralSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    }
    
    func request(_ request: URLRequest) {
        session.dataTask(with: request).resume()
    }
    
    func request(_ request: SimpleHttpRequest, callback: @escaping (SimpleHttpResponse) -> Void) {
        do {
            let task = try createTask(with: request, callback: callback)
            task.resume()
        } catch {
            callback(SimpleHttpResponse(customError: error))
        }
    }
    
    func createTask(with request: SimpleHttpRequest, callback: @escaping (SimpleHttpResponse) -> Void) throws -> URLSessionDataTask {
        if let urlRequest = request.urlRequest() {
            let task = self.createTask(with: urlRequest, isEphemeral: request.isEphemeral) { (data, response, error) in
                let simpleHttpResponse = SimpleHttpResponse(request: request, data: data, urlResponse: response, error: error)
                callback(simpleHttpResponse)
            }
            return task
        } else {
            throw SimpleHttpResponse.Errors.invalidUrl
        }
    }
    
    func createTask(with urlRequest: URLRequest, isEphemeral: Bool, callback: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let sess = isEphemeral ? ephemeralSession : session
        return sess.dataTask(with: urlRequest, completionHandler: callback)
    }
    
}
//
//fileprivate extension Logger.Domain {
//    static let simpleHttpManager = Logger.Domain(rawValue: "SimpleHttpManager")
//}
