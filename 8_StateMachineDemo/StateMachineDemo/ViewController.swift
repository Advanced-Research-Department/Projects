//
//  ViewController.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 26.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SimpleAppLaunchStateMachineListener {
    // MARK: - IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginResultLabel: UILabel!

    // MARK: - Private Properties
    private var stateMacnihe: SimpleAppLaunchStateMachineProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    // MARK: - Public Methods
    func showError(_ message: String, onDismiss: @escaping () -> Void) {
        showDialog(title: "Error", message: message, onDismiss: onDismiss)
    }

    func showMaintenance(onDismiss: @escaping () -> Void) {
        showDialog(title: "Maintenance", message: "Maintenance message stub", onDismiss: onDismiss)
    }
    
    func showMultiEnvironmentSelector(_ message: String, onDismiss: @escaping () -> Void) {
        showDialog(title: "Environment Selector", message: "Choose any environment: \n\(message)", onDismiss: onDismiss)
    }
    
    // MARK: - Private Methods
    private func prepareUI() {
        showActivityIndicator(false)
        loginResultLabel.isHidden = true
    }
    
    private func startAppLauch() {
        showActivityIndicator(true)
//        stateMacnihe = SimpleAppLaunchStateMachine(listener: self)
        stateMacnihe = MultyEnvironmentAppLaunchStateMachine(listener: self)
        stateMacnihe?.startLaunching()
    }
    
    private func showActivityIndicator(_ show: Bool) {
        activityIndicator.isHidden = !show
    }
    
    private func displayResultMessage(_ message: String) {
        loginResultLabel.isHidden = false
        loginResultLabel.text = message
    }
    
    private func processResult(_ result: LaunchResult) -> String {
        switch result {
        case .success(let location):
            return "That's all, \(location) folks"
        case .failure(let error):
            return "Hey, it's an error: \(error)"
        }
    }
    
    private func showDialog(title: String, message: String, onDismiss: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .cancel) { _ in
            onDismiss()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func startLogin(_ sender: Any) {
        startAppLauch()
    }
    
    // MARK: - SimpleAppLaunchStateMachineListener methods
    func onAppLaunchFinishedWithResult(_ result: LaunchResult) {
        showActivityIndicator(false)
        let resultMessage = processResult(result)
        displayResultMessage(resultMessage)
        stateMacnihe = nil
    }
}
