//
//  LSMStageRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 19.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMStageRM {
    // Stage<T: BaseMatch>: SimpleStage<T>
    let dataName: String?
    let isCountry: Bool
    let hidden: Bool
    let hasShortLeagueTable: Bool
    // SimpleStage<T: BaseMatch>: BaseStage
    let numberOfParticipants: Int
    let leagueTables: LSMLeagueTableListRM?
    let events: [LSMEventRM]?
    // BaseStage: SimpleDataProcessingModel
    let stageId: String?
    let name: String?
    let shortName: String?
    let categoryName: String?
    let categoryShortName: String?
    let categoryCode: String?
    let categoryId: String?
    let code: String?
    let seasonCode: String?
    let isCup: Bool
    
    init?(_ data: NSDictionary?) {
        guard let data = data else { return nil }
        
        // Stage<T: BaseMatch>: SimpleStage<T>
        dataName = JSONUtils.getStringFromJSON(data, name: "Sdn")
        isCountry = JSONUtils.getIntFromJSON(data, name: "Ccntr") == 1
        hidden = JSONUtils.getIntFromJSON(data, name: "Shi") == 1
        hasShortLeagueTable = JSONUtils.getIntFromJSON(data, name: "SLTxha") == 1
        // SimpleStage<T: BaseMatch>: BaseStage
        numberOfParticipants = JSONUtils.getIntFromJSON(data, name: "Spps", defaultVal: 16)
        leagueTables = LSMLeagueTableListRM(data.object(forKey: "LeagueTable") as? NSDictionary)
        if let eventsData = JSONUtils.getArrayFromJSON(data, name: "Events") {
            var events = [LSMEventRM]()
            for data in eventsData {
                if let event = LSMEventRM(data as? NSDictionary) {
                    events.append(event)
                }
            }
            self.events = events
        } else {
            events = nil
        }
        // BaseStage: SimpleDataProcessingModel
        stageId = JSONUtils.getForceStringFromJSON(data, name: "Sid2") ?? JSONUtils.getForceStringFromJSON(data, name: "Sid")       // Old server - Sid2, New server - "Sid
        code = JSONUtils.getStringFromJSON(data, name: "Scd")
        name = JSONUtils.getStringFromJSON(data, name: "Snm")
        shortName = JSONUtils.getStringFromJSON(data, name: "Sds")
        categoryCode = JSONUtils.getStringFromJSON(data, name: "Ccd")
        categoryId = JSONUtils.getForceStringFromJSON(data, name: "Cid")
        seasonCode = JSONUtils.getStringFromJSON(data, name: "CcdDef")
        categoryName = JSONUtils.getStringFromJSON(data, name: "Cnm")
        categoryShortName = JSONUtils.getStringFromJSON(data, name: "Csnm")
        isCup = JSONUtils.getIntFromJSON(data, name: "Scu", defaultVal: 0) == 1
    }
}

extension LSMStageRM: CustomStringConvertible {
    var description: String {
        var description = "LSStageRM {"
        if let stageId = stageId { description += "\nstageId: \(stageId)" }
        if let name = name { description += "\nname: \(name)" }
        if let shortName = shortName { description += "\nshortName: \(shortName)" }
        if let categoryName = categoryName { description += "\ncategoryName: \(categoryName)" }
        if let categoryShortName = categoryShortName { description += "\ncategoryShortName: \(categoryShortName)" }
        if let categoryCode = categoryCode { description += "\ncategoryCode: \(categoryCode)" }
        if let categoryId = categoryId { description += "\ncategoryId: \(categoryId)" }
        if let code = code { description += "\ncode: \(code)" }
        if let seasonCode = seasonCode { description += "\nseasonCode: \(seasonCode)" }
        description += "\nisCup: \(isCup)"
        if let events = events { description += "\nevents: \(events)" }
        description += "\n}"
        return description
    }
}
