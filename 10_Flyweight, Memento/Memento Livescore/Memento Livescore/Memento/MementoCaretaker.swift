//
//  MementoCaretaker.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 05.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import UIKit

protocol MementoCaretakerProtocol {
    func add(match: SimpleMatchMemento)
    func undo() -> SimpleMatchMemento?
}

class MementoCaretaker: MementoCaretakerProtocol {
 
    private var matches: [SimpleMatchMemento] = []
    
    func add(match: SimpleMatchMemento) {
        matches.append(match)
    }
    
    // go to previous item
    func undo() -> SimpleMatchMemento? {
        return matches.popLast()
    }
}
