//
//  LSMScoresDataLoader.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 19.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct BaseStage {}

protocol LSMScoresDataLoaderProtocol: DataLoaderProtocol {
    func isNotModified()
    func didFinishLoadWith(data: LSMScoresRM?)
}

class LSMScoresDataLoader: DataLoader {
    
    weak var delegate: LSMScoresDataLoaderProtocol?
    
    var payload: HttpBodyConvertable?
    var payloadIds: NSSet?
    var ifModifiedSince: String?
    var options: DataLoadOptions?
    var cachePeriod: TimeInterval?
    var filter: ((BaseMatch) -> Bool)?
    var usePost: Bool = false
    var sport: Sport = .Soccer
    
    private let context: String = "LSScoresDataLoader" + UUID().uuidString
    
    func loadData(page: Page, sport: Sport, categoryCode: String? = nil, stageCode: String? = nil, date: Date? = nil ) {
        self.sport = sport
        
        let url: URL?
        
        var options = DataLoadOptions()
        if sport == .Cricket {
            options = options.union(.IgnoreDates)
        }
        self.options = options
        
//        if let date = date {
//            url = AppContext.shared.appState.webUrlProvider?.dateUrlForSport(sport, date: date)
//        } else if let categoryCode = categoryCode,
//            let stageCode = stageCode {
//            url = AppContext.shared.appState.webUrlProvider?.stageUrlForSport(sport, categoryCode: categoryCode, stageCode: stageCode)
//        } else if let categoryCode = categoryCode {
//            url = AppContext.shared.appState.webUrlProvider?.stageUrlForSport(sport, categoryCode: categoryCode)
//        } else {
//            url = AppContext.shared.appState.webUrlProvider?.stageUrlForSport(sport)
//        }
        
         url = URL(string: "https://api.livescore.com/~~/app/09/category/soccer/2020-04-08/3/")
        
        if let requestUrl = url {
            loadData(url: requestUrl, sport: sport)
        } else {
            delegate?.didFailedLoadWith(error: ApiDataProviderFailureReason.invalidUrl)
        }
    }
    
    func loadData(url: URL, sport: Sport) {
        onStart()
        
        LSMRequestManager.shared.getStage(context: context,
                                         url: url,
                                         sport: sport,
                                         payload: payload,
                                         payloadIds: payloadIds,
                                         ifModifiedSince: ifModifiedSince,
                                         options: options,
                                         cachePeriod: cachePeriod,
                                         filter: filter,
                                         usePost: usePost) {
                                            [weak self] result in
                                            switch result {
                                            case .success(let data, let lastModified):
                                                self?.didFinishLoadWith(data: data, lastModified: lastModified)
                                            case .isNotModified:
                                                self?.isNotModified()
                                            case .failure(let error):
                                                self?.didFailedLoadWith(error: error)
                                            }
        }
    }
    
    // MARK: - Responce handling
    private func didFinishLoadWith(data: NSDictionary, lastModified: String?) {
        let parser = LSMScoresParser()
        let result = parser.parse(data: data, sport: sport, options: options)
        delegate?.didFinishLoadWith(data: result.stages)
    }
    
    private func isNotModified() {
        DispatchQueue.main.async {
            self.delegate?.isNotModified()
        }
    }
    
    private func didFailedLoadWith(error: Error?) {
        DispatchQueue.main.async {
            self.delegate?.isNotModified()
        }
    }
    
    // MARK: - Favourites
    func clearInvalidSubscriptions(stages: [BaseStage]?) {}
}

