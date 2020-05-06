//
//  MementoCaretaker.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 05.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import UIKit

protocol MementoCaretakerProtocol {
    func add(match: SimpleMatchSnapshot)
    func undo() -> SimpleMatchSnapshot?
}

class MementoCaretaker: MementoCaretakerProtocol {
 
    private var matches: [SimpleMatchSnapshot] = []
    
    func add(match: SimpleMatchSnapshot) {
        matches.append(match)
    }
    
    // go to previous item
    func undo() -> SimpleMatchSnapshot? {
        return matches.popLast()
    }
}
