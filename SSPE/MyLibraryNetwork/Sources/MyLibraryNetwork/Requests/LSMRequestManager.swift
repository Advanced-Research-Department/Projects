//
//  LSMRequestManager.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 19.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMApiRequestData {
    var request: ApiRequest
    var context: String
    var needToDecrypt: Bool!
    var sport: Sport?
    var options: DataLoadOptions?
    
    init(request: ApiRequest, context: String, needToDecrypt: Bool? = false, sport: Sport? = nil, options: DataLoadOptions? = nil) {
        self.request = request
        self.context = context
        self.needToDecrypt = needToDecrypt
        self.sport = sport
        self.options = options
    }
}

enum LSMRequestManagerResult {
    case success(NSDictionary, String?)
    case isNotModified
    case failure(ApiDataProviderFailureReason)
}

class LSMRequestManager {//: ErrorEventTrackable {
    static let shared = LSMRequestManager()
    let dataProvider = LSMApiDataProvider()
    
    func cancelRequest(for context: String) {
        dataProvider.cancelLoadRequest(context: context)
    }
    
    //For requests via ApiDataProvider
    func performApiRequest(apiRequestData: LSMApiRequestData, useCaching: Bool = false, completion: @escaping (LSMRequestManagerResult) -> Void) {
        let responseHandler: (LSMApiResponse) -> Void = {
            [weak self] response in
            
            if let error = response.error {
                if (response.error as NSError?)?.code == NSURLErrorCancelled {
                    //TODO: Add action for cancelled requests
                } else {
                    let statusCode = (error as NSError).code == ApiDataProviderFailureReason.timeout.statusCode ?
                        ApiDataProviderFailureReason.timeout.statusCode :
                        (response.statusCode ?? ApiDataProviderFailureReason.undefined.statusCode)
                    if statusCode >= 400 || statusCode == ApiDataProviderFailureReason.timeout.statusCode {
//                        self?.trackErrorEvent(urlString: apiRequestData.request.url.absoluteString, statusCode: statusCode)
                    }
                    completion(.failure(.invalidResponse(description: error.localizedDescription)))
                }
            } else if let d = response.data {
                do {
                    let result = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    completion(.success(result, response.lastModified))
                } catch {
//                    self?.trackErrorEvent(urlString: apiRequestData.request.url.absoluteString, statusCode: ApiDataProviderFailureReason.invalidJson.statusCode)
                    completion(.failure(.invalidJson))
                }
            } else if response.isNotModified {
                completion(.isNotModified)
            } else {
                completion(.failure(.undefined))
            }
        }
        
        if useCaching {
            self.dataProvider.loadCachedData(request: apiRequestData.request,
                                             context: apiRequestData.context, 
                                             needToDecrypt: apiRequestData.needToDecrypt,
                                             callback: responseHandler)
        } else {
            self.dataProvider.loadData(request: apiRequestData.request,
                                       context: apiRequestData.context,
                                       needToDecrypt: apiRequestData.needToDecrypt,
                                       callback: responseHandler)
        }
    }
}

extension LSMRequestManager  {
    func getStage(context: String,
                  url: URL,
                  sport: Sport,
                  needToDecrypt: Bool = true,
                  payload: HttpBodyConvertable? = nil,
                  payloadIds: NSSet? = nil,
                  ifModifiedSince: String? = nil,
                  options: DataLoadOptions? = nil,
                  cachePeriod: TimeInterval? = nil,
                  filter: ((BaseMatch) -> Bool)? = nil,
                  usePost: Bool = false,
                  completion: @escaping (_ resul: LSMRequestManagerResult) -> Void) {
        
        let request = ApiRequest(url: url,
                                 payload: payload,
                                 payloadIds: payloadIds,
                                 ifModifiedSince: ifModifiedSince,
                                 options: options ?? DataLoadOptions(),
                                 filter: filter,
                                 usePost: usePost)
        
        let requestData = LSMApiRequestData(request: request,
                                           context: context,
                                           needToDecrypt: needToDecrypt,
                                           sport: sport,
                                           options: options)
        
        performApiRequest(apiRequestData: requestData, useCaching: true, completion: completion)
    }
}
