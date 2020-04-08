//
//  LSScoresParser.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 19.03.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

class LSMScoresParser: LSMParser {
    func parse(data: NSDictionary, sport: Sport, options: DataLoadOptions? = nil) -> (stages: LSMScoresRM?, error: Error?) {
        guard let rmModel = LSMScoresRM(data),
            let rmStages = rmModel.stages else { return (stages: nil, error: nil) }
        
//        var stages = [LSMStage]()
//        for rmStage in rmStages {
//            if let stage = LSMStage(rm: rmStage) {
//                stages.append(stage)
//            }
//        }
        
        return (stages: rmModel, error: nil)
    }
}
