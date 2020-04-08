//
//  LSMLeagueTableRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 20.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMLeagueTableRM {
    let tableTypeId: Int
    let typedName: String?
    let teams: [LSMTeamLeagueTableRM]?
    let phaseIds: [LSMPhaseIdsRM]?
    
    init?(_ data: NSDictionary?) {
        guard let data = data else { return nil }
        
        tableTypeId = JSONUtils.getIntFromJSON(data, name: "LTT", defaultVal: 0)
        typedName = JSONUtils.getStringFromJSON(data, name: "name")
        if let teamsData = JSONUtils.getArrayFromJSON(data, name: "team") {
            var teams = [LSMTeamLeagueTableRM]()
            for d in teamsData {
                if let team = LSMTeamLeagueTableRM(d as? NSDictionary) {
                    teams.append(team)
                }
            }
            self.teams = teams
        } else {
            teams = nil
        }
        if let phases = JSONUtils.getArrayFromJSON(data, name: "phrX") {
            var phaseIds = [LSMPhaseIdsRM]()
            for d in phases {
                if let phaseId = LSMPhaseIdsRM(d as? NSDictionary) {
                    phaseIds.append(phaseId)
                }
            }
            self.phaseIds = phaseIds
        } else {
            phaseIds = nil
        }
    }
}

extension LSMLeagueTableRM: CustomStringConvertible {
    var description: String {
        var description = "LSMLeagueTableListRM {"
        description += "\ntableTypeId: \(tableTypeId)"
        if let typedName = typedName { description += "\ntypedName: \(typedName)" }
        if let teams = teams { description += "\nteams: \(teams)" }
        if let phaseIds = phaseIds { description += "\nphaseIds: \(phaseIds)" }
        description += "\n}"
        return description
    }
}

struct LSMPhaseIdsRM {
    let id: Int
    let determined: NSNumber?
    
    init?(_ data: NSDictionary?) {
        guard let data = data,
            let id = data.object(forKey: "V") as? Int else { return nil }
        self.id = id
        determined = data.object(forKey: "D") as? NSNumber
    }
}

extension LSMPhaseIdsRM: CustomStringConvertible {
    var description: String {
        var description = "LSMPhaseIdsRM {\nid:\(id)"
        if let determined = determined { description += "\ndetermined: \(determined.boolValue)" }
        description += "\n}"
        return description
    }
}
