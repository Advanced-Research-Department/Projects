//
//  LSMTeamLeagueTableRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 20.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMTeamLeagueTableRM {
    let teamId: String?
    let providerId: String?
    let partTeamId: String?
    let teamName: String?
    let partTeamName: String?
    let shortName: String?
    let points: Int?
    let pointModifier: Int?
    let percentWon: Double?
    let matches: Int?
    let wins: Int?
    let draws: Int?
    let losses: Int?
    let goalsScored: Int?
    let goalsReceived: Int?
    let goalDiff: Int?
    let rank: Int?
    let inProgressVal: Int?
    let winsOverTime: Int?
    let winsAfterPenalties: Int?
    let lossesOverTime: Int?
    let lossesAfterPenalties: Int?
    let winsRegularTime: Int?
    let lossesRegularTime: Int?
    let winsRegularOrOT: Int?
    let lossesRegularOrOT: Int?
    let separator: Bool
    let players: [LSMPersonRM]?
    let advancePhases: [Int]?
    let notes: [String]?
    
    init?(_ data: NSDictionary?) {
        guard let data = data else { return nil }
        
        teamId = JSONUtils.getForceStringFromJSON(data, name: "Tid")
        providerId = JSONUtils.getForceStringFromJSON(data, name: "Pid")
        partTeamId = JSONUtils.getForceStringFromJSON(data, name: "Ptid")
        teamName = JSONUtils.getStringFromJSON(data, name: "Tnm")
        partTeamName = JSONUtils.getStringFromJSON(data, name: "Ptn")
        shortName = JSONUtils.getStringFromJSON(data, name: "Tsn")
        points = JSONUtils.getIntFromJSON(data, name: "pts", defaultVal: 0)
        pointModifier = JSONUtils.getIntFromJSON(data, name: "ptsX")
        percentWon = JSONUtils.getDoubleFromJSON(data, name: "per")
        matches = JSONUtils.getIntFromJSON(data, name: "pld", defaultVal: 0)
        wins = JSONUtils.getIntFromJSON(data, name: "win", defaultVal: 0)
        draws = JSONUtils.getIntFromJSON(data, name: "drw", defaultVal: 0)
        losses = JSONUtils.getIntFromJSON(data, name: "lst", defaultVal: 0)
        goalsScored = JSONUtils.getIntFromJSON(data, name: "gf", defaultVal: 0)
        goalsReceived = JSONUtils.getIntFromJSON(data, name: "ga", defaultVal: 0)
        goalDiff = JSONUtils.getIntFromJSON(data, name: "gd", defaultVal: 0)
        rank = JSONUtils.getIntFromJSON(data, name: "rnk", defaultVal: 0)
        inProgressVal = JSONUtils.getIntFromJSON(data, name: "Ipr", defaultVal: 0)
        winsOverTime = JSONUtils.getIntFromJSON(data, name: "wot", defaultVal: 0)
        winsAfterPenalties = JSONUtils.getIntFromJSON(data, name: "wap", defaultVal: 0)
        lossesOverTime = JSONUtils.getIntFromJSON(data, name: "lot", defaultVal: 0)
        lossesAfterPenalties = JSONUtils.getIntFromJSON(data, name: "lap", defaultVal: 0)
        winsRegularTime = JSONUtils.getIntFromJSON(data, name: "wreg", defaultVal: 0)
        lossesRegularTime = JSONUtils.getIntFromJSON(data, name: "lreg", defaultVal: 0)
        winsRegularOrOT = JSONUtils.getIntFromJSON(data, name: "wregot", defaultVal: 0)
        lossesRegularOrOT = JSONUtils.getIntFromJSON(data, name: "lregot", defaultVal: 0)
        separator = JSONUtils.getIntFromJSON(data, name: "ng") == 1
        if let playersData = JSONUtils.getArrayFromJSON(data, name: "Players") {
            var players = [LSMPersonRM]()
            for d in playersData {
                if let player = LSMPersonRM(d as? NSDictionary) {
                    players.append(player)
                }
            }
            self.players = players
        } else {
            players = nil
        }
        advancePhases = JSONUtils.getArrayFromJSON(data, name: "phr") as? [Int]
        notes = JSONUtils.getStringArrayFromJSON(data, name: "com")
    }
}

extension LSMTeamLeagueTableRM: CustomStringConvertible {
    var description: String {
        var description = "LSMLeagueTableListRM {"
        if let teamId = teamId {description += "\nteamId: \(teamId)" }
        if let providerId = providerId {description += "\nproviderId: \(providerId)" }
        if let partTeamId = partTeamId {description += "\npartTeamId: \(partTeamId)" }
        if let teamName = teamName { description += "\nteamName: \(teamName)" }
        if let partTeamName = partTeamName { description += "\npartTeamName: \(partTeamName)" }
        if let shortName = shortName { description += "\nshortName: \(shortName)" }
        if let points = points { description += "\npoints: \(points)" }
        if let pointModifier = pointModifier { description += "\npointModifier: \(pointModifier)" }
        if let percentWon = percentWon { description += "\npercentWon: \(percentWon)" }
        if let matches = matches { description += "\nmatches: \(matches)" }
        if let wins = wins { description += "\nwins: \(wins)" }
        if let draws = draws { description += "\ndraws: \(draws)" }
        if let losses = losses { description += "\nlosses: \(losses)" }
        if let goalsScored = goalsScored { description += "\ngoalsScored: \(goalsScored)" }
        if let goalsReceived = goalsReceived { description += "\ngoalsReceived: \(goalsReceived)" }
        if let goalDiff = goalDiff { description += "\ngoalDiff: \(goalDiff)" }
        if let rank = rank { description += "\nrank: \(rank)" }
        if let inProgressVal = inProgressVal { description += "\ninProgressVal: \(inProgressVal)" }
        if let winsOverTime = winsOverTime { description += "\nwinsOverTime: \(winsOverTime)" }
        if let winsAfterPenalties = winsAfterPenalties { description += "\nwinsAfterPenalties: \(winsAfterPenalties)" }
        if let lossesOverTime = lossesOverTime { description += "\nlossesOverTime: \(lossesOverTime)" }
        if let lossesAfterPenalties = lossesAfterPenalties { description += "\nlossesAfterPenalties: \(lossesAfterPenalties)" }
        if let winsRegularTime = winsRegularTime { description += "\nwinsRegularTime: \(winsRegularTime)" }
        if let lossesRegularTime = lossesRegularTime { description += "\nlossesRegularTime: \(lossesRegularTime)" }
        if let winsRegularOrOT = winsRegularOrOT { description += "\nwinsRegularOrOT: \(winsRegularOrOT)" }
        if let lossesRegularOrOT = lossesRegularOrOT { description += "\nlossesRegularOrOT: \(lossesRegularOrOT)" }
        description += "\nseparator: \(separator)"
        if let players = players { description += "\nplayers: \(players)" }
        if let advancePhases = advancePhases { description += "\nadvancePhases: \(advancePhases)" }
        if let notes = notes { description += "\nnotes: \(notes)" }
        description += "\n}"
        return description
    }
}
