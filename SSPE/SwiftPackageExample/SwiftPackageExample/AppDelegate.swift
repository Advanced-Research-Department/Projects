//
//  AppDelegate.swift
//  SwiftPackageExample
//
//  Created by Oleksiy Zhuk on 08.04.2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = TestViewController()
        window!.makeKeyAndVisible()
        
        return true
    }
}

