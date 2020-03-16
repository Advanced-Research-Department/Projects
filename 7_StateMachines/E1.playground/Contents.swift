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

class SimpleStateMachine {
    var state: State = .off {
        didSet{ print("\t\t\tstate changed to \(state)") }
    }
    
    func processEvent(_ event: Event) {
        print("\(event) happened")
        switch (state, event) {
        case (.on, .turnOff): do {
            print( "\tturning off")
            state = .off
            }
        case (.off, .turnOn): do {
            print( "\tturning on")
            state = .on
            }
        case (.on, .toggle): fallthrough
        case (.off, .toggle): do {
            print( "\tchaning state to opposite")
            state = state == .on ? .off : .on
            }
        case (.off, .turnOff): fallthrough
        case (.on, .turnOn): print( "\talready in that state. idle...")
        default: print( "\tundefined behavior. idle...")
        }
    }
}

let stateMachine = SimpleStateMachine()
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
