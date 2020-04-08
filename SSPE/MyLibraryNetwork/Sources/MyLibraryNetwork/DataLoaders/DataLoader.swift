//
//  DataLoader.swift
//  LiveScore_v3
//
//  Created by Oleksiy Zhuk on 4/22/19.
//  Copyright © 2019 LiveScore. All rights reserved.
//

import Foundation

protocol DataLoaderProtocol: class {
    func didFailedLoadWith(error: Error?)
}

class DataLoader: NSObject {
    
    func onStart() {
//        NetworkActivityIndicatorControl.sharedInstance.startIndicator()
    }
    
    func onFinish() {
//        NetworkActivityIndicatorControl.sharedInstance.stopIndicator()
    }
}
