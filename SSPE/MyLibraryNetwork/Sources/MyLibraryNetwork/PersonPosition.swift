//
//  PersonPosition.swift
//  LiveScore v3
//
//  Created by vaclav on 11/02/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

import Foundation

enum PersonPosition: Int {
    case unknown = 0
    case goalkeeper = 1
    case defender = 2
    case midfielder = 3
    case forward = 4
    case substitute = 5
    case injured = 7
    case suspended = 8
    case unavailable = 9
    case coach = 10
    case pitcher = 11
    case batter = 12
    case doubtful = 13
    case starter = 14
    case leftBack = 15
    case leftWing = 16
    case rightBack = 17
    case rightWing = 18
    case center = 19
    case pivot = 20
    case playMaker = 21
    case offensiveLine = 30
    case defensiveLine = 31
    case offensiveBack = 40
    case defensiveBack = 41
    case runningBack = 42
    case quarterBack = 43
    case slotBack = 44
    case halfBack = 45
    case lineBacker = 50
    case kicker = 51
    case placeKicker = 52
    case tightEnd = 60
    case splitEnd = 61
    case `guard` = 70
    case shootingGuard = 71
    case pointGuard = 72
    case smallForward = 76
    case powerForward = 77
    case firstBase = 80
    case secondBase = 81
    case thirdBase = 82
    case outfield = 84
    case leftOutfield = 87
    case centerOutfield = 88
    case rightOutfield = 89
    case catcher = 90
    case punter = 91
    case utilityPlayer = 92
    case reliever = 93
    case starterGuy = 94
    case shortStop = 95
    case designatedHitter = 96
    case wideReceiver = 97
    case coachManager = 100
    case coachAssistant = 101
    case coachSuspended = 102
    case nationalTeamDuty = 105
    case captain = 123
    case wicketKeeper = 124
    case captainWicketKeeper = 125
    
    static func isSubstitute(_ position: PersonPosition?) -> Bool {
        return position == PersonPosition.substitute
    }
    
    static func isStarter(_ position: PersonPosition?) -> Bool {
        return position == PersonPosition.goalkeeper ||
            position == PersonPosition.defender ||
            position == PersonPosition.midfielder ||
            position == PersonPosition.forward ||
            position == PersonPosition.starter ||
            position == PersonPosition.captain ||
            position == PersonPosition.captainWicketKeeper ||
            position == PersonPosition.wicketKeeper
    }
    
    static func isCoach(_ position: PersonPosition?) -> Bool {
        return position == PersonPosition.coach ||
            position == PersonPosition.coachManager ||
            position == PersonPosition.coachAssistant ||
            position == PersonPosition.coachSuspended
    }
    
    static func ordering(_ position: PersonPosition) -> Int {
        switch position {
        case PersonPosition.captainWicketKeeper:
            return 1
        case PersonPosition.captain:
            return 2
        case PersonPosition.wicketKeeper:
            return 3
        case PersonPosition.unknown:
            return 1000
        default:
            return position.rawValue + 3
        }
    }
}
