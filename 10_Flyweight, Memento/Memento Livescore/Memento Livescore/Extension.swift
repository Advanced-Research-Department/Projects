//
//  Extension.swift
//  Memento Livescore
//
//  Created by Maxim Yevtuhivskiy on 06.05.2020.
//  Copyright © 2020 LiveScore. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class var identifier: String {
        return String(describing: self)
    }
}

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
