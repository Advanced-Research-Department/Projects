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
/// Just everybody's father (or mother)
class BasicAppLaunchState: State, Equatable {
    let machine: SimpleAppLaunchStateMachine
    
    static func == (lhs: BasicAppLaunchState, rhs: BasicAppLaunchState) -> Bool {
        return lhs === rhs
    }
    
    init(_ stateMachine: SimpleAppLaunchStateMachine) {
        self.machine = stateMachine
    }

    // MARK: - State Protocol conformance
    func enter() {
    }
    
    func exit() {
    }
}


// MARK: - Specific States
/// Doing nothing, my favorite job
class StateIdle: BasicAppLaunchState {
}


/// Are you in the correct place?
class StateGetGeoLocation: BasicAppLaunchState {
    private let geolocationHelper = GeoLocaitonHelper()
    
    override func enter() {
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


/// Reach out and touch faith
class StateDownloadEnvironmentConfig: BasicAppLaunchState {
    private let environmentConfigHelper: EnvironmentConfigHelper
    private let location: String
    
    init(stateMachine: SimpleAppLaunchStateMachine, for location: String) {
        self.location = location
        self.environmentConfigHelper = EnvironmentConfigHelper(location: location)
        super.init(stateMachine)
    }
    
    override func enter() {
        environmentConfigHelper.loadEnvironmentConfig(onSuccess: { config in
            proceedWithConfig(config)
        }, onFail: { error in
            machine.switchState(from: self, to: machine.getStateShowErrorMessageState(error))
        })
    }
    
    private func proceedWithConfig(_ config: EnvironmentConfig) {
        if config.isMaintenance {
            machine.switchState(from: self, to: machine.getShowMaintenanceState(location: location))
        } else {
            let nextState = self.machine.getDeliverResultState(.success(location: location))
            self.machine.switchState(from: self, to: nextState)

        }
    }
}


/// No way, my friend: Maintenance screen
class StateShowMaintenance: BasicAppLaunchState {
    private let uiHelper = UIHelper()
    private let location: String

    init(stateMachine: SimpleAppLaunchStateMachine, location: String) {
        self.location = location
        super.init(stateMachine)
    }
    
    override func enter() {
        uiHelper.showMaintenance {
            // TODO: Schedule update in EnvironmentConfigHelper and subscribe for it
            // download config until maintenance is off
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let nextState = self.machine.getDownloadEnvironmentState(for: self.location)
                self.machine.switchState(from: self, to: nextState)
            }
        }
    }
}


/// All good (not really)
class StateShowErrorMessage: BasicAppLaunchState {
    private let error: Error
    private let uiHelper = UIHelper()

    init(stateMachine: SimpleAppLaunchStateMachine, error: Error) {
        self.error = error
        super.init(stateMachine)
    }
    
    override func enter() {
        uiHelper.showErrorMessage(error.self.localizedDescription) {
            let nextState = self.machine.getDeliverResultState(.failure(error: self.error))
            self.machine.switchState(from: self, to: nextState)
        }
    }
}


/// You are almost done, just one step to go
class StateDeliverResult: BasicAppLaunchState {
    private let result: LaunchResult
    
    init(stateMachine: SimpleAppLaunchStateMachine, result: LaunchResult) {
        self.result = result
        super.init(stateMachine)
    }

    override func enter() {
        machine.switchState(from: self, to: machine.getIdleState())
    }
    
    override func exit() {
        machine.deliverResult(result: result)
    }
}


/// Time to check what is inside...
class StateProcessConfig: BasicAppLaunchState {
    private let config: EnvironmentConfig
    private let location: String

    init(stateMachine: SimpleAppLaunchStateMachine, config: EnvironmentConfig, location: String) {
        self.config = config
        self.location = location
        super.init(stateMachine)
    }
    
    override func enter() {
       proceedWithConfig(config)
    }
    
    private func proceedWithConfig(_ config: EnvironmentConfig) {
        if config.isMaintenance {
            machine.switchState(from: self, to: machine.getShowMaintenanceState(location: location))
        } else {
            let nextState = self.machine.getDeliverResultState(.success(location: location))
            self.machine.switchState(from: self, to: nextState)
        }
    }
}
