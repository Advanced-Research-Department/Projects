//
//  UIHelper.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 31.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation
import UIKit


struct UIHelper {
    // I know, it's not good
    private let viewController: ViewController = UIApplication.topViewController()! as! ViewController
    
    func showErrorMessage(_ message: String, onDismiss: @escaping () -> Void) {
        viewController.showError(message, onDismiss: onDismiss)
    }
    
    func showEnvironmentSelector(_ environments: [EnvironmentConfig], onDismiss: @escaping (EnvironmentConfig) -> Void) {
        let message = environments.map{$0.name}.joined(separator: "\n")
        viewController.showMultiEnvironmentSelector(message) {
            onDismiss(environments.first!) // remebmer, it's a demo
        }
    }
    
    func showMaintenance(onDismiss: @escaping () -> Void) {
        viewController.showMaintenance(onDismiss: onDismiss)
    }
}
