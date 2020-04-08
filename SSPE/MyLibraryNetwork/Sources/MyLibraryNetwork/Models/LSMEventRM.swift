//
//  LSMEventRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 19.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMEventRM {
    let schedStartDateNum: NSNumber?
    
    let legacyMatchIds: [LSMLegacyMatchIdsRM]?
    let defaultProvider: NSNumber?
    let matchIds: [String:String]?
    let matchType: MatchType
    let overallStatusId: OverallStatus
    let eventOptions: Int
    let isHidden: Bool
    
    init?(_ data: NSDictionary?) {
        guard let data = data else { return nil }
        
        schedStartDateNum = data.object(forKey: "Esd") as? NSNumber
        defaultProvider = data.object(forKey: "Pid") as? NSNumber
        if let ids = data.object(forKey: "IDs") as? NSArray {
            var matchIds = [LSMLegacyMatchIdsRM]()
            for id in ids {
                if let mIds = LSMLegacyMatchIdsRM(id as? NSDictionary) {
                    matchIds.append(mIds)
                }
            }
            legacyMatchIds = matchIds
        } else {
            legacyMatchIds = nil
        }
        matchIds = data.object(forKey: "Pids") as? [String:String]
        matchType = MatchType(rawValue: JSONUtils.getIntFromJSON(data, name: "Et", defaultVal: -1)) ?? .unknown
        overallStatusId = OverallStatus(rawValue: JSONUtils.getIntFromJSON(data, name: "Epr", defaultVal: -1)) ?? .unknown
        eventOptions = JSONUtils.getIntFromJSON(data, name: "EO", defaultVal: 0)
        isHidden = JSONUtils.getBoolFromJSON(data, name: "Ehid")
    }
}

extension LSMEventRM: CustomStringConvertible {
    var description: String {
        var description = "LSMEventRM {"
        if let schedStartDateNum = schedStartDateNum { description += "\nschedStartDateNum:\(schedStartDateNum)" }
        if let legacyMatchIds = legacyMatchIds { description += "\nlegacyMatchIds:\(legacyMatchIds)" }
        if let defaultProvider = defaultProvider { description += "\ndefaultProvider:\(defaultProvider)" }
        if let matchIds = matchIds { description += "\nmatchIds:\(matchIds)" }
        description += "\nmatchType:\(matchType)"
        description += "\noverallStatusId:\(overallStatusId)"
        description += "\neventOptions:\(eventOptions)"
        description += "\nisHidden:\(isHidden)"
        description += "\n}"
        return description
    }
}

struct LSMLegacyMatchIdsRM {
    let pid: Int
    let mid: Int
    let primary: Bool
    
    init?(_ data: NSDictionary?) {
        guard let data = data,
            let pid = data.object(forKey: "P") as? NSNumber,
            let mid = data.object(forKey: "ID") as? NSNumber else { return nil }
            
        self.pid = pid.intValue
        self.mid = mid.intValue
        if let d = data.object(forKey: "d") as? NSNumber {
            primary = d.intValue == 1
        } else {
            primary = false
        }
    }
}

extension LSMLegacyMatchIdsRM: CustomStringConvertible {
    var description: String { return "LSMLegacyMatchIdsRM {\npid:\(pid)\nmid:\(mid)\nprimary:\(primary)\n}" }
}
