//
//  JSONFactory.swift
//  BDModules
//
//  Created by Patrick Hogan on 3/3/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation

public class JSONFactory {
    
    // MARK:- Injectable
    
    public lazy var userDefaults = UserDefaults()
    
    // MARK:- Intialization
    
    public init() { }
    
    // MARK:- Logging
    public lazy var logger: Logger = {
        let logger = Logger(tag: "JSON", applicationName: "BDModules")
        let loggerSettings = self.userDefaults.loggerSettings
        logger.enabled = loggerSettings.isLoggerEnabled(logger)
        logger.thresholdLevel = loggerSettings.loggerLevel(logger)
        logger.synchronous = true
        return logger
        }()
    
    // MARK:- JSON
    
    public lazy var jsonSerializer: JSONSerializer = {
        let jsonSerializer = JSONSerializer()
        jsonSerializer.logWarning = log(self.logger, .Warning)
        return jsonSerializer
        }()

}
