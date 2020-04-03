//
//  State.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 26.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation

protocol State {
    func enter()
    func exit()
}
