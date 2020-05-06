//
//  SimpleMatch.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 05.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

protocol SimpleMatchSnapshot {
    
}

class SimpleMatch: SimpleMatchSnapshot {
    
    var homeTeam: String = ""
    var awayTeam: String = ""
    var isHomeTeamWin: Bool = false
    var testNumber: Int = 0

    init(homeTeam: String, awayTeam: String, isHomeTeamWin: Bool, testNumber: Int) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.isHomeTeamWin = isHomeTeamWin
        self.testNumber = testNumber
    }
}
