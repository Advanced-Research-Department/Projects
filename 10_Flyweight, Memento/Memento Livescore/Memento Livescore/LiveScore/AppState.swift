//
//  AppState.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 05.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

class AppState {
    
    var matchDetailsCaretaker: MementoCaretakerProtocol
    
    init() {
        matchDetailsCaretaker = MementoCaretaker()
    }
}
