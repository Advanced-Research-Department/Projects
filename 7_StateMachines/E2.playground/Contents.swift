import UIKit

enum State {
    case on
    case off
}

enum Event {
    case turnOn
    case turnOff
    case toggle
    case broke
}

//  #### #  #  ------turnOn------>>  #### #### ####
//  #  # ## #                        #  # #    #
//  #  # # ##  <<----toggle------>>  #  # #### ####
//  #  # #  #                        #  # #    #
//  #### #  #  <<----turnOff-------  #### #    #

protocol StateMachineEventHandler {
    var state: State { get }
    func processEvent(_ event: Event) -> StateMachineEventHandler?
}

class OffStateMachineEventHandler: StateMachineEventHandler {
    var state: State { return .off }
    func processEvent(_ event: Event) -> StateMachineEventHandler? {
        switch event {
        case .turnOn: fallthrough
        case .toggle: do {
            print( "\tturning on")
            return OnStateMachineEventHandler()
            }
        case .turnOff: print( "\talready in that state. idle...")
        default: print( "\tundefined behavior. idle...")
        }
        return nil
    }
}

class OnStateMachineEventHandler: StateMachineEventHandler {
    var state: State { return .on }
    func processEvent(_ event: Event) -> StateMachineEventHandler? {
        switch event {
        case .turnOff: fallthrough
        case .toggle: do {
            print( "\tturning off")
            return OffStateMachineEventHandler()
            }
        case .turnOn: print( "\talready in that state. idle...")
        default: print( "\tundefined behavior. idle...")
        }
        return nil
    }
}

class StateMachine {
    private var eventHandler: StateMachineEventHandler = OffStateMachineEventHandler() {
        didSet{ print("\t\t\tstate changed to \(state)") }
    }

    var state: State { return eventHandler.state }
    
    func processEvent(_ event: Event) {
        print("\(event) happened")
        if let eh = eventHandler.processEvent(event) {
            eventHandler = eh
        }
    }
}

let stateMachine = StateMachine()
stateMachine.processEvent(.turnOn)
stateMachine.processEvent(.turnOff)
stateMachine.processEvent(.turnOff)
stateMachine.processEvent(.turnOn)
stateMachine.processEvent(.turnOn)
stateMachine.processEvent(.toggle)
stateMachine.processEvent(.toggle)
stateMachine.processEvent(.toggle)
stateMachine.processEvent(.turnOff)
stateMachine.processEvent(.broke)
