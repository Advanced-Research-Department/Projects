//
//  GeoLocationHelper.swift
//  StateMachineDemo
//
//  Created by Oleksandr Murashchenko on 31.03.2020.
//  Copyright © 2020 Oleksandr Murashchenko. All rights reserved.
//

import Foundation

struct GeoLocaitonHelper {
    // like in real world, bitch
    private let geoLocationURL = "https://ads.cc/me"
    
    func fetchGeoLocation(onSuccess: (GeoLocation) -> Void, onFail: (Error) -> Void) {
        // TEST CODE: success simulation
        onSuccess(GeoLocation.Default)
        
        // TEST CODE: failure simulation
//        onFail(GeoLocationError.locationDatabaseError)
    }
}


/// Just a wrapper for your convenience
struct GeoLocation {
    let countryCode: String
    let isValid: Bool
    
    static let Default = GeoLocation(countryCode: "UA", isValid: true)
}


// MARK: GeoLocation errors
enum GeoLocationError: Error {
    case locationNotAvailable
    case locationDatabaseError
    case invalidLocation
}


extension GeoLocationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .locationNotAvailable:
            return NSLocalizedString("GeoLocationError.locationNotAvailable", comment: "whooo-hooo")
        case .locationDatabaseError:
            return NSLocalizedString("GeoLocationError.locationDatabaseError", comment: "whooo-hooo")
        case .invalidLocation:
            return NSLocalizedString("GeoLocationError.invalidLocation", comment: "whooo-hooo")
        }
    }
}
