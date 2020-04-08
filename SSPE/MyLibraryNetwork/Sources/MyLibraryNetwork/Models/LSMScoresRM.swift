//
//  LSMScoresRM.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 23.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

struct LSMScoresRM {
    let stages: [LSMStageRM]?
    
    init?(_ data: NSDictionary?) {
        guard let stagesData = data?["Stages"] as? NSArray else { return nil }
        
        var stages = [LSMStageRM]()
        for data in stagesData {
            if let stage = LSMStageRM(data as? NSDictionary) {
                stages.append(stage)
            }
        }
        
        self.stages = stages
    }
}

extension LSMScoresRM: CustomStringConvertible {
    var description: String {
        var description = "LSMScoresRM {"
        if let stages = stages { description += "\nstages: \(stages)" }
        description += "\n}"
        return description
    }
}
