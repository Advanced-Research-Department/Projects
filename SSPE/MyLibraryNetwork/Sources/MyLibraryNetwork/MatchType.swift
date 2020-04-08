//
//  MatchType.swift
//  LiveScore v3
//
//  Created by vaclav on 09/06/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

import Foundation

enum MatchType: Int {
    case unknown = 0
    case teamToTeam = 1
    case maleSingle = 10
    case maleDouble = 11
    case femaleSingle = 15
    case femaleDouble = 16
    case mixed = 20
    case single = 22
    case double = 23
    case match40Over = 40
    case match45Over = 45
    case match50Over = 50
    case t20 = 100
    case t20International = 101
    case odi = 151
    case odiMoreDay = 120
    case moreDayMatch = 150
    case icc = 160
    case testCricket = 170
}
