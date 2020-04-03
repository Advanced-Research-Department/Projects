//
//  MultyEnvironmentAppLaunchStates.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 01.04.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation


/// Let's be polygamous
class StateDownloadMultyEnvironmentConfig: BasicAppLaunchState {
    private let environmentConfigHelper: EnvironmentConfigHelper
    private let location: String
    
    init(stateMachine: SimpleAppLaunchStateMachine, for location: String) {
        self.location = location
        self.environmentConfigHelper = EnvironmentConfigHelper(location: location)
        super.init(stateMachine)
    }
    
    override func enter() {
        // Crappy, better to use protocol, but it's 1am already and I'm going to sleep
        let machine = self.machine as! MultyEnvironmentAppLaunchStateMachine
        environmentConfigHelper.loadMultyEnvironmentConfig(onSuccess: { multyConfig in
            machine.switchState(from: self, to: machine.getShowMultyEnvironmentState(multyConfig.environments, for: location))
        }, onFail: { error in
            machine.switchState(from: self, to: machine.getStateShowErrorMessageState(GeoLocationError.invalidLocation))
        })
    }
}


/// Test as much as you can
class StateShowMultyEnvironmentSelector: BasicAppLaunchState {
    private let uiHelper = UIHelper()
    private let environments: [EnvironmentConfig]
    private let location: String

    init(stateMachine: SimpleAppLaunchStateMachine, environments: [EnvironmentConfig], for location: String) {
        self.environments = environments
        self.location = location
        super.init(stateMachine)
    }
    
    override func enter() {
        uiHelper.showEnvironmentSelector(environments, onDismiss: { environment in
            let nextState = self.machine.getProcessConfigState(environment, location: self.location)
            self.machine.switchState(from: self, to: nextState)
        })
    }
}

