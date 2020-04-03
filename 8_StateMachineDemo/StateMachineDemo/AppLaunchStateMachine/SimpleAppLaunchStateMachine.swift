//
//  BaseAppLaunchStateMachine.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 26.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation
import UIKit

/// On result callback listener
protocol SimpleAppLaunchStateMachineListener {
    func onAppLaunchFinishedWithResult(_ result: LaunchResult)
}


/// Public Interface to use from outside
protocol SimpleAppLaunchStateMachineProtocol {
    init(listener: SimpleAppLaunchStateMachineListener)
    func startLaunching()
    func deliverResult(result: LaunchResult)
}


/// Only two cases how it can finish
enum LaunchResult {
    case success(location: String)
    case failure(error: Error)
}


class SimpleAppLaunchStateMachine: BasicStateMachineImpl<BasicAppLaunchState>, SimpleAppLaunchStateMachineProtocol {
    // MARK: - Private Properties
    private let listener: SimpleAppLaunchStateMachineListener // notify when it's done
    
    // MARK: - Initializers
    required init(listener: SimpleAppLaunchStateMachineListener) {
        self.listener = listener
        super.init()
        // initial state
        self.activeState = StateIdle(self)
    }
    
    // MARK: - SimpleAppLaunchStateMachineProtocol impl
    func startLaunching() {
        switchState(from: activeState, to: getGeoLocationState())
    }
    
    func deliverResult(result: LaunchResult) {
        listener.onAppLaunchFinishedWithResult(result)
    }
    
    // MARK: - Wrapper getters for all states
    func getIdleState() -> BasicAppLaunchState {
        return StateIdle(self)
    }
    
    func getGeoLocationState() -> BasicAppLaunchState {
        return StateGetGeoLocation(self)
    }
    
    func getDownloadEnvironmentState(for location: String) -> BasicAppLaunchState {
        return StateDownloadEnvironmentConfig(stateMachine: self, for: location)
    }
    
    func getProcessConfigState(_ config: EnvironmentConfig, location: String) -> BasicAppLaunchState {
        return StateProcessConfig(stateMachine: self, config: config, location: location)
    }
    
    func getShowMaintenanceState(location: String) -> BasicAppLaunchState {
        return StateShowMaintenance(stateMachine: self, location: location)
    }
    
    func getStateShowErrorMessageState(_ error: Error) -> BasicAppLaunchState {
        return StateShowErrorMessage(stateMachine: self, error: error)
    }
    
    func getDeliverResultState(_ result: LaunchResult) -> BasicAppLaunchState {
        return StateDeliverResult(stateMachine: self, result: result)
    }
}
