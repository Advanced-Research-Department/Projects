//
//  Sport.swift
//  LiveScore v3
//
//  Created by vaclav on 11/02/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

import Foundation

enum Sport: String, Equatable, CaseIterable {
    case Soccer = "soccer"
    case Hockey = "hockey"
    case Basketball = "basketball"
    case Tennis = "tennis"
    case Cricket = "cricket"
    
    static var allSports: [Sport] { return [.Soccer, .Hockey, .Basketball, .Tennis, .Cricket] }
    
    static func ==(lhs: Sport, rhs: Sport) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    var contentMode: LeagueContentMode {
        switch self {
        case .Soccer:
            return .soccerMode
        case .Basketball:
            return .basketballMode
        default:
            return .defaultMode
        }
    }
    
    var serverIdentifier: String {
        switch self {
        case .Soccer: return "1"
        case .Hockey: return "5"
        case .Basketball: return "23"
        case .Tennis: return "2"
        case .Cricket: return "73"
        }
    }
    
}

enum LeagueContentMode {
    case defaultMode
    case soccerMode
    case basketballMode
}
