//
//  LSMLeagueTableListRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 20.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMLeagueTableListRM {
    let tableGroups: [LSMLeagueTableGroupRM]?
    
    init?(_ data: NSDictionary?) {
        guard let data = data, let tableData = data.object(forKey: "L") as? NSArray else { return nil }
        var tableGroups = [LSMLeagueTableGroupRM]()
        for d in tableData {
            if let group = LSMLeagueTableGroupRM(d as? NSDictionary) {
                tableGroups.append(group)
            }
        }
        self.tableGroups = tableGroups
    }
}

extension LSMLeagueTableListRM: CustomStringConvertible {
    var description: String {
        var description = "LSMLeagueTableListRM {"
        if let tableGroups = tableGroups { description += "\ntableGroups: \(tableGroups)" }
        description += "\n}"
        return description
    }
}
