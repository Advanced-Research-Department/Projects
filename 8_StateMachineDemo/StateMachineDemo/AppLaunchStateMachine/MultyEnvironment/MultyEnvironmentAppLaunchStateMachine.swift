//
//  MultyEnvironmentAppLaunchStateMachine.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 31.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation


class MultyEnvironmentAppLaunchStateMachine: SimpleAppLaunchStateMachine {
    
    // MARK: - Wrapper getters for Mutly case states
    override func getDownloadEnvironmentState(for location: String) -> BasicAppLaunchState {
        return getDownloadMultyEnvironmentState(for: location)
    }
    
    func getShowMultyEnvironmentState(_ environments: [EnvironmentConfig], for location: String) -> BasicAppLaunchState {
        return StateShowMultyEnvironmentSelector(stateMachine: self, environments: environments, for: location)
    }
    
    // MARK: - Private getters
    private func getDownloadMultyEnvironmentState(for location: String) -> BasicAppLaunchState {
        return StateDownloadMultyEnvironmentConfig(stateMachine: self, for: location)
    }
}
