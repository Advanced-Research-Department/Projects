//
//  AppLaunchStates.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 31.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Basic State
// Just everybody's father (or mother)
class BasicAppLaunchState: State, Equatable {
    let machine: SimpleAppLaunchStateMachineImpl
    
    static func == (lhs: BasicAppLaunchState, rhs: BasicAppLaunchState) -> Bool {
        return lhs === rhs
    }
    
    init(_ stateMachine: SimpleAppLaunchStateMachineImpl) {
        self.machine = stateMachine
    }
}


// MARK: - Specific States
// Doing nothing, my favorite job
class StateIdle: BasicAppLaunchState {
}


// Are you in the correct place?
class StateGetGeoLocation: BasicAppLaunchState {
    private let geolocationHelper = GeoLocaitonHelper()
    
    func enter() {
        geolocationHelper.fetchGeoLocation(onSuccess: { location in
            self.proceedGeoLocation(location)
        }) { locationError in
            machine.switchState(from: self, to: machine.getStateShowErrorMessageState(locationError))
        }
    }
    
    private func proceedGeoLocation(_ location: GeoLocation) {
        guard location.isValid else {
            machine.switchState(from: self, to: machine.getStateShowErrorMessageState(GeoLocationError.invalidLocation))
            return
        }
        
        machine.switchState(from: self, to: machine.getDownloadEnvironmentState(for: location.countryCode))
    }
}


// Time to check what is inside...
class StateDownloadEnvironmentConfig: BasicAppLaunchState {
    private let environmentConfigHelper: EnvironmentConfigHelper
    private let location: String
    
    init(stateMachine: SimpleAppLaunchStateMachineImpl, for location: String) {
        self.location = location
        self.environmentConfigHelper = EnvironmentConfigHelper(location: location)
        super.init(stateMachine)
    }
    
    func enter() {
        environmentConfigHelper.loadEnvironmentConfig(onSuccess: { config in
            
        }) { error in
            
        }
        
        
//        geolocationHelper.fetchGeoLocation(onSuccess: { countryCode in
//            machine.switchState(from: self, to: machine.getDownloadEnvironmentState(for: c))
//        }) { locationError in
//            machine.switchState(from: self, to: machine.getStateDeliverResultState(.failure(error: locationError)))
//        }
    }
    
    private func proceedWithConfig() {
        
    }
}


// No way, my friend: Maintenance screen
class StateShowMaintenance: BasicAppLaunchState {
    private let geolocationHelper = GeoLocaitonHelper()
    
//    func enter() {
//        geolocationHelper.fetchGeoLocation(onSuccess: { countryCode in
//            machine.switchState(from: self, to: machine.getDownloadEnvironmentState())
//        }) { locationError in
//
//            machine.deliverResult(result: .failure(error: locationError))
//        }
//    }
    
    private func proceedWithConfig() {
        
    }
}


// All good (not really)
class StateShowErrorMessage: BasicAppLaunchState {
    private let error: Error
    private let uiHelper = UIHelper()

    init(stateMachine: SimpleAppLaunchStateMachineImpl, error: Error) {
        self.error = error
        super.init(stateMachine)
    }
    
    func enter() {
        uiHelper.showErrorMessage(error.self.localizedDescription) {
            machine.switchState(from: self, to: machine.getStateDeliverResultState(.failure(error: error)))
        }
    }
}


// You are almost done, just one step to go
class StateDeliverResult: BasicAppLaunchState {
    private let result: LaunchResult
    
    init(stateMachine: SimpleAppLaunchStateMachineImpl, result: LaunchResult) {
        self.result = result
        super.init(stateMachine)
    }

    func enter() {
        machine.switchState(from: self, to: machine.getIdleState())
    }
    
    func exit() {
        machine.deliverResult(result: result)
    }
}


// StateGetGeoLocation
// StateDownloadEnvironmentConfig
// StateSelectEnvironment
// StateShowMaintenance
// StateShowErrorMessage
// StateDeliverResult
//


// StateShowMultyEnvironmentSelector
// StateDownloadMultyEnvironmentConfig

