//
//  LSMPersonRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 23.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMPersonRM {
    let personId: String?
    var name: String?
    var shortName: String?
    var firstName: String?
    var lastName: String?
    let minuteIn: Int?
    let minuteOut: Int?
    let shirtNumber: Int?
    let position: PersonPosition
    let fieldPosision: String?
    
    init?(_ data: NSDictionary?) {
        guard let data = data else { return nil }
        
        personId = JSONUtils.getForceStringFromJSON(data, name: "Pid")
        name = JSONUtils.getStringFromJSON(data, name: "Nm")
        shortName = JSONUtils.getStringFromJSON(data, name: "Nms")
        firstName = JSONUtils.getStringFromJSON(data, name: "Fn")
        lastName = JSONUtils.getStringFromJSON(data, name: "Ln")
        minuteIn = JSONUtils.getIntFromJSON(data, name: "Mi")
        minuteOut = JSONUtils.getIntFromJSON(data, name: "Mo")
        shirtNumber = JSONUtils.getIntFromJSON(data, name: "Snu")
        fieldPosision = JSONUtils.getStringFromJSON(data, name: "Fp")
        position = PersonPosition(rawValue: JSONUtils.getIntFromJSON(data, name: "Pos", defaultVal: 0)) ?? .unknown
    }
}

extension LSMPersonRM: CustomStringConvertible {
    var description: String {
        var description = "LSMPersonRM {"
        if let personId = personId { description += "\npersonId: \(personId)" }
        if let name = name { description += "\nname: \(name)" }
        if let shortName = shortName { description += "\nshortName: \(shortName)" }
        if let firstName = firstName { description += "\nfirstName: \(firstName)" }
        if let lastName = lastName { description += "\nlastName: \(lastName)" }
        if let minuteIn = minuteIn { description += "\nminuteIn: \(minuteIn)" }
        if let minuteOut = minuteOut { description += "\nminuteOut: \(minuteOut)" }
        if let shirtNumber = shirtNumber { description += "\nshirtNumber: \(shirtNumber)" }
        if let fieldPosision = fieldPosision { description += "\nfieldPosision: \(fieldPosision)" }
        description += "\nposition: \(position)"
        description += "\n}"
        return description
    }
}
