//
//  OverallStatus.swift
//  LiveScore v3
//
//  Created by vaclav on 23/02/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

import Foundation

enum OverallStatus: Int {
    case notStarted = 0
    case inProgress = 1
    case finished = 2
    case canceled = 3
    case postponed = 4
    case unknown = 5
    case interrupted = 6
    
    func toMatchState() -> String {
        switch self {
        case .notStarted:   return "notStarted"
        case .inProgress:   return "live"
        case .finished:     return "finished"
        case .canceled:     return "canceled"
        case .postponed:    return "postponed"
        case .unknown:      return "unknown"
        case .interrupted:  return "interrupted"
        }
    }
}
