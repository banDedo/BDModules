//
//  JSONFactory.swift
//  BDModules
//
//  Created by Patrick Hogan on 3/3/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation

public class JSONFactory {
    
    // MARK:- Intialization
    
    public init() { }
    
    // MARK:- Logging
    public lazy var logger: Logger = {
        let logger = Logger(tag: "JSON", applicationName: "BDModules")
        logger.enabled = true
        logger.synchronous = true
        logger.thresholdLevel = .Warning
        return logger
        }()
    
    // MARK:- JSON
    
    public lazy var jsonSerializer: JSONSerializer = {
        let jsonSerializer = JSONSerializer()
        jsonSerializer.logWarning = log(self.logger, .Warning)
        return jsonSerializer
        }()

}
