//
//  EnvironmentConfigHelper.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 31.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation


// MARK: The helper and its bitch
struct EnvironmentConfigHelper {
   
    // like in real world
    private let geoLocationURL = "https://internet.com/environment.json"
    private let location: String
    
    init(location: String) {
        self.location = location
    }
    
    func loadEnvironmentConfig(onSuccess: (EnvironmentConfig) -> Void, onFail: (EnvironmentConfigError) -> Void) {
        // TEST CODE: success simulation
        onSuccess(EnvironmentConfig.Default)
        
        // TEST CODE: failure simulation
        // onFail(EnvironmentConfigError.parsingError)
    }
    
    func loadMultyEnvironmentConfig(onSuccess: (MultyEnvironmentConfig) -> Void, onFail: (EnvironmentConfigError) -> Void) {
        // TEST CODE: success simulation
        onSuccess(MultyEnvironmentConfig.Default)
        
        // TEST CODE: failure simulation
        // onFail(EnvironmentConfigError.parsingError)
        }
}


// Just for example, not for work
struct EnvironmentConfig {
    let name: String
    let backendHost: String
    let isMaintenance: Bool
    
    static let Default = EnvironmentConfig(name: "PROD", backendHost: "hornsandhooves.com", isMaintenance: false)

}

// Just for example, not for work
struct MultyEnvironmentConfig {
    let environments: [EnvironmentConfig]
    
    static let Default = MultyEnvironmentConfig(environments: [EnvironmentConfig(name: "PROD", backendHost: "hornsandhooves.com", isMaintenance: true),
                                                               EnvironmentConfig(name: "DEV", backendHost: "hornsandhooves.com", isMaintenance: false),
                                                               EnvironmentConfig(name: "TEST", backendHost: "hornsandhooves.com", isMaintenance: false)])
}

// MARK: Environment errors
enum EnvironmentConfigError: Error {
    case loadingError
    case parsingError
    case contentValidationError
}

extension EnvironmentConfigError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .loadingError:
            return NSLocalizedString("EnvironmentConfigError.loadingError", comment: "EnvironmentConfigError")
        case .parsingError:
            return NSLocalizedString("EnvironmentConfigError.parsingError", comment: "EnvironmentConfigError")
        case .contentValidationError:
            return NSLocalizedString("EnvironmentConfigError.contentValidatioonError", comment: "EnvironmentConfigError")
        }
    }
}
