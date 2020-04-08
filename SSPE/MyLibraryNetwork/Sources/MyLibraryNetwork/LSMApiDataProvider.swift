//
//  LSMApiDataProvider.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 18.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

fileprivate struct LSMApiDataProviderErrors {
    static let invalidUrlError = NSError(domain: "Invalid URL", code: 999999, userInfo: nil)
    static let invalidJsonError = NSError(domain: "Invalid JSON", code: 9997, userInfo: nil)
    static let decryptionError = NSError(domain: "Decryption error", code: 9998, userInfo: nil)
}

class LSMApiDataProvider {
    private let decryptUtil = DecryptUtil()
    
    private let syncQueue = DispatchQueue(label: "com.livescore.ApiDataSyncQueue." + UUID().uuidString)
    private var tasks = [String: URLSessionTask]()
    
//    func loadLiveMatchesCountData(request: ApiRequest, callback: @escaping (ApiResponse<[Sport : Int]>) -> Void) {
//        loadData(request: request) { response in
//            var liveCounts: [Sport : Int]?
//            if !response.isNotModified, let d = response.data {
//                liveCounts = self.dataParser.parseLiveMatchesCounts(from: d)
//            }
//            DispatchQueue.main.async {
//                callback(ApiResponse(data: liveCounts, dataProviderResponse: response))
//            }
//        }
//    }
    
//    func loadStageData<T>(request: ApiRequest, callback: @escaping (ApiResponse<[Stage<T>]>) -> Void) {
//        loadData(request: request) { response in
//            var stages: [Stage<T>]?
//            if !response.isNotModified, let d = response.data {
//                stages = self.dataParser.parseStagesFromData(d, options: request.options, subscribedIds: request.payloadIds, filter: request.filter)
//            }
//            DispatchQueue.main.async {
//                callback(ApiResponse(data: stages, dataProviderResponse: response))
//            }
//        }
//    }
//
//    func loadLiveMatchCounts(_ callback: @escaping ([Sport: Int]?) -> Void) {
//
//        var result = [Sport: Int]()
//
//        func invokeCallback() {
//            if result.count >= 5 {
//                callback(result)
//            }
//        }
//
//        if let url = AppContext.shared.appState.webUrlProvider?.liveMatchesCountsUrl() {
//            // Trying to get data from new sever
//            let liveMatchesCountsRequest = ApiRequest(url: url)
//            loadLiveMatchesCountData(request: liveMatchesCountsRequest) { (response) in
//                result = response.data ?? [:]
//                invokeCallback()
//            }
//        } else {
//            if let webUrlProvider = AppContext.shared.appState.webUrlProvider {
//
//                if let url = webUrlProvider.stageUrlForSport(Sport.Soccer) {
//                    let soccerRequest = ApiRequest(url: url)
//                    loadStageData(request: soccerRequest) { (response: ApiResponse<[Stage<SoccerMatch>]>) in
//                        result[Sport.Soccer] = self.countEventsInStages(response.data)
//                        invokeCallback()
//                    }
//                }
//
//                if let url = webUrlProvider.stageUrlForSport(Sport.Hockey) {
//                    let hockeyRequest = ApiRequest(url: url)
//                    loadStageData(request: hockeyRequest) { (response: ApiResponse<[Stage<HockeyMatch>]>) in
//                        result[Sport.Hockey] = self.countEventsInStages(response.data)
//                        invokeCallback()
//                    }
//                }
//
//                if let url = webUrlProvider.stageUrlForSport(Sport.Basketball) {
//                    let basketballRequest = ApiRequest(url: url)
//                    loadStageData(request: basketballRequest) { (response: ApiResponse<[Stage<BasketMatch>]>) in
//                        result[Sport.Basketball] = self.countEventsInStages(response.data)
//                        invokeCallback()
//                    }
//                }
//
//                if let url = webUrlProvider.stageUrlForSport(Sport.Tennis) {
//                    let tennisRequest = ApiRequest(url: url)
//                    loadStageData(request: tennisRequest) { (response: ApiResponse<[Stage<TennisMatch>]>) in
//                        result[Sport.Tennis] = self.countEventsInStages(response.data)
//                        invokeCallback()
//                    }
//                }
//
//                if let url = webUrlProvider.stageUrlForSport(Sport.Cricket) {
//                    let cricketRequest = ApiRequest(url: url)
//                    loadStageData(request: cricketRequest) { (response: ApiResponse<[Stage<CricketMatch>]>) in
//                        result[Sport.Cricket] = self.countEventsInStages(response.data)
//                        invokeCallback()
//                    }
//                }
//            } else {
//                callback(nil)
//            }
//        }
//    }
    
    func cancelLoadRequest(context: String) {
        syncQueue.async {
            if let task = self.tasks.removeValue(forKey:context), task.state == .running {
                task.cancel()
            }
        }
    }
    
    func loadData(request: ApiRequest,
                  context: String,
                  needToDecrypt: Bool = true,
                  callback: @escaping (LSMApiResponse) -> Void) {
        if request.usePost && request.payload == nil {
            callback(LSMApiResponse(data: nil, lastModified: nil, isNotModified: false, error: nil))
        } else {
            loadRawData(request: request, context: context) { response in
                var dataResponse: LSMApiResponse
                if response.isNotModified && response.error == nil && response.lastModified != nil {
                    dataResponse = LSMApiResponse(data: nil, simpleHttpResponse: response)
                } else if let data = self.dataFromResponse(response, needToDecrypt: needToDecrypt) {
                    dataResponse = LSMApiResponse(data: data, simpleHttpResponse: response)
                } else {
                    dataResponse = LSMApiResponse(customError: response.error ?? LSMApiDataProviderErrors.decryptionError, statusCode: response.statusCode)
                }
                callback(dataResponse)
            }
        }
    }
    
    func loadCachedData(request: ApiRequest,
                        context: String,
                        needToDecrypt: Bool = true,
                        callback: @escaping (LSMApiResponse) -> Void) {
        self.loadData(request: request, context: context, needToDecrypt: needToDecrypt) { response in
            var apiResponse: LSMApiResponse
            
            if response.statusCode == 304 {
                let cachedData = LSMDataCache.sharedInstance.dataForKey(request.url.absoluteString)
                if let c = cachedData {
                    apiResponse = LSMApiResponse(data: c.data, lastModified: c.lastModified, isNotModified: response.isNotModified, error: nil)
                } else {
                    apiResponse = LSMApiResponse(data: nil, lastModified: nil, isNotModified: false, error: nil)
                }
            } else if let d = response.data {
                apiResponse = response
                if let m = response.lastModified {
                    LSMDataCache.sharedInstance.setData(d, lastModified: m, forKey: request.url.absoluteString)
                } else {
                    LSMDataCache.sharedInstance.setData(d, forKey: request.url.absoluteString)
                }
            } else {
                apiResponse = response
            }
            
            DispatchQueue.main.async {
                callback(apiResponse)
            }
        }
    }
    
//    private func countEventsInStages<T>(_ stages: [SimpleStage<T>]?) -> Int {
//        var count = 0
//        if let s = stages {
//            for stage in s {
//                count += stage.liveMatchCount()
//            }
//        }
//        return count
//    }
    
    private func loadRawData(request: ApiRequest, context: String, callback: @escaping (SimpleHttpResponse) -> Void) {
        syncQueue.async {
//            NetworkActivityIndicatorControl.sharedInstance.startIndicator()
            do {
                self.tasks.removeValue(forKey: context)?.cancel()
                let task = try SimpleHttpManager.sharedInstance.createTask(with: request.simpleHttpRequest) { response in
                    self.tasks.removeValue(forKey: context)
//                    NetworkActivityIndicatorControl.sharedInstance.stopIndicator()
                    callback(response)
                }
                self.tasks[context] = task
                task.resume()
            } catch {
//                NetworkActivityIndicatorControl.sharedInstance.stopIndicator()
                callback(SimpleHttpResponse(customError: error))
            }
        }
    }
    
    // helper func
    private func dataFromResponse(_ response: SimpleHttpResponse, needToDecrypt: Bool) -> Data? {
        guard let data = response.data else { return nil }
        
        return needToDecrypt ? self.decryptUtil.decrypt(data) : data
    }
}

