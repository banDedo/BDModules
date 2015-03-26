//
//  UserDefaults.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation
import MapKit

private let kUserDefaultsLastUserLocationKey = "lastUserLocation"
private let kUserDefaultsLoggerSettingsKey = "loggerSettings"

public let kUserDefaultsLastUserLocationLatitudeKey = "latitude"
public let kUserDefaultsLastUserLocationLongitudeKey = "longitude"

public class UserDefaults {
    
    // MARK:- Injectable
    
    public lazy var suiteName: String = ""

    // MARK:- Defaults

    public var lastUserLocation: NSDictionary? {
        get {
            return userDefaults.objectForKey(kUserDefaultsLastUserLocationKey) as? NSDictionary
        }
        set {
            userDefaults.setObject(newValue, forKey: kUserDefaultsLastUserLocationKey)
            userDefaults.synchronize()
        }
    }

    public var loggerSettings: LoggerSettings {
        get {
            if let data = userDefaults.objectForKey(kUserDefaultsLoggerSettingsKey) as? NSData {
                let loggerSettings = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! LoggerSettings
                return loggerSettings
            } else {
                return LoggerSettings()
            }
        }
        set {
            let data = NSKeyedArchiver.archivedDataWithRootObject(newValue)
            userDefaults.setObject(data, forKey: kUserDefaultsLoggerSettingsKey)
            userDefaults.synchronize()
        }
    }

    // MARK:- Private properties
    
    private lazy var userDefaults: NSUserDefaults = {
        let userDefaults = count(self.suiteName) > 0 ?
            NSUserDefaults(suiteName: self.suiteName)! :
            NSUserDefaults()
        return userDefaults
    }()
    
}
