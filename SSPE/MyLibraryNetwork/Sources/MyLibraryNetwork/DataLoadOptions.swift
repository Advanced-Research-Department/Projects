//
//  DataLoadOptions.swift
//  LiveScore v3
//
//  Created by vaclav on 26/08/16.
//  Copyright © 2016 LiveScore. All rights reserved.
//

public struct DataLoadOptions: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public init() {
        self.rawValue = 0x0000
    }
    public static var IgnoreDates = DataLoadOptions(rawValue: 0x0001)
    public static var IgnoreCache = DataLoadOptions(rawValue: 0x0002)
    public static var TimeInUTC = DataLoadOptions(rawValue: 0x0004)
}
