//
//  LSMLeagueTableGroupRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 20.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMLeagueTableGroupRM {
    let tables: [LSMLeagueTableRM]?
    let name: String?
    
    init?(_ data: NSDictionary?) {
        guard let data = data,
            let tableData = data.object(forKey: "Tables") as? NSArray else { return nil }
        var tables = [LSMLeagueTableRM]()
        for d in tableData {
            if let table = LSMLeagueTableRM(d as? NSDictionary) {
                tables.append(table)
            }
        }
        self.tables = tables
        name = data.object(forKey: "Nm") as? String
    }
}

extension LSMLeagueTableGroupRM: CustomStringConvertible {
    var description: String {
        var description = "LSMLeagueTableListRM {"
        if let tables = tables { description += "\ntables: \(tables)" }
        if let name = name { description += "\nname: \(name)" }
        description += "\n}"
        return description
    }
}
