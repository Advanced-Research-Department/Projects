//
//  BasicStateMachine.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 26.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation


// General State Machine, not related to any specific functionality
protocol BasicStateMachine {
    associatedtype StateType: State, Equatable
    
    var activeState: StateType? {get set}
    func switchState(from old: StateType?, to newState:StateType?)
}



// Super implementation for all state machines to be inhereted from
class BasicStateMachineImpl<T: State & Equatable>: BasicStateMachine {
    var activeState: T?
    
    func switchState(from oldState: T?, to newState:T?) {
        guard activeState == oldState else {
            print("StateMachine::switchState: Unexpected current state: \(String(describing: oldState.self)), expected: ")
            fatalError()
        }
        print("StateMachine::switchState: from: \(String(describing: oldState.self)), to: \(String(describing: newState.self))")

        // finishing with the past
        if let _ = oldState {
            oldState!.exit()
        }

        // looking to the future
        activeState = newState
        if let _ = activeState {
            activeState!.enter()
        }
    }
}
