//
//  LoggerSettings.swift
//  Pods
//
//  Created by Patrick Hogan on 3/24/15.
//
//

import UIKit

private let kLoggerSettingsMapKey = "kLoggerSettingsMapKey"

private let kLoggerSettingsEnabledKey = "enabled"
private let kLoggerSettingsLevelKey = "level"

public class LoggerSettings: NSObject, NSCoding {
    
    // MARK:- Properties
    
    private(set) public var map = [ String: [ String: AnyObject ] ]()
    
    // MARK: - Constructor
    
    public override init() { }
    
    // MARK:- NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        map = aDecoder.decodeObjectForKey(kLoggerSettingsMapKey) as! [ String: [ String: AnyObject ] ]
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(map, forKey: kLoggerSettingsMapKey)
    }
    
    // MARK:- Logger Settings
    
    public func isLoggerEnabled(logger: Logger) -> Bool {
        if let isLoggerEnabled = map[logger.tag]?[kLoggerSettingsEnabledKey] as? Bool {
            return isLoggerEnabled
        } else {
            return false
        }
    }
    
    public func loggerLevel(logger: Logger) -> Logger.Level {
        if let rawValue = map[logger.tag]?[kLoggerSettingsLevelKey] as? Int {
            return Logger.Level(rawValue: rawValue)!
        } else {
            return .Error
        }
    }
    
    public func updateLogger(logger: Logger) {
        var mapValue = map[logger.tag]
        if mapValue == nil {
            mapValue = [ String: AnyObject ]()
        }
        mapValue![kLoggerSettingsEnabledKey] = logger.enabled
        mapValue![kLoggerSettingsLevelKey] = logger.thresholdLevel.rawValue
        map[logger.tag] = mapValue
    }
    
}
