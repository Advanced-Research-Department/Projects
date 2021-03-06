//
//  MementoProtocol.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 05.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import Foundation

protocol MementoProtocol: class {
     func save()
     func restore() -> SimpleMatch?
}
