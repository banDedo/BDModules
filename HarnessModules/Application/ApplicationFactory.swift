//
//  ApplicationFactory.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/20/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public class ApplicationFactory {
    
    // MARK:- Factories
    
    public let apiFactory = APIFactory()
    public let entryFactory = EntryFactory()
    public let jsonFactory = JSONFactory()
    public let mainFactory = MainFactory()
    public let modelFactory = ModelFactory()

    // MARK:- RootViewController

    public func rootViewController() -> RootViewController {
        let rootViewController = RootViewController()
        rootViewController.accountUserProvider = apiFactory.accountUserProvider
        rootViewController.entryFactory = entryFactory
        rootViewController.mainFactory = mainFactory
        return rootViewController
    }

    // MARK:- Constructor

    public init() {

        // ModelFactory
        
        modelFactory.jsonSerializer = jsonFactory.jsonSerializer
        modelFactory.logError = log(modelLogger, .Error)
        modelFactory.objectMapperPair = ModelFactoryMapper.objectMapperPair(modelFactory)

        // APIFactory
        
        apiFactory.jsonSerializer = jsonFactory.jsonSerializer
        apiFactory.modelFactory = modelFactory

        // JSONFactory
        
        jsonFactory.userDefaults = apiFactory.userDefaults

        // EntryFactory
        
        entryFactory.apiFactory = apiFactory
        
        // MainFactory
        
        mainFactory.apiFactory = apiFactory
        mainFactory.applicationLifecycleLogger = logger
        mainFactory.jsonFactory = jsonFactory
        mainFactory.modelLogger = modelLogger

    }
    
    // MARK:- Initial injection

    public func inject(appDelegate: AppDelegate) {
        appDelegate.appLifecycleLogger = logger
        appDelegate.rootViewController = rootViewController()
    }

    // MARK:- Application
    
    public lazy var logger: Logger = {
        let logger = Logger(tag: "Application Lifecycle", applicationName: "BDModules")
        let loggerSettings = self.apiFactory.userDefaults.loggerSettings
        logger.enabled = loggerSettings.isLoggerEnabled(logger)
        logger.thresholdLevel = loggerSettings.loggerLevel(logger)
        logger.synchronous = true
        return logger
        }()

    // MARK:- ModelFactory

    public lazy var modelLogger: Logger = {
        let logger = Logger(tag: "Model", applicationName: "BDModules")
        let loggerSettings = self.apiFactory.userDefaults.loggerSettings
        logger.enabled = loggerSettings.isLoggerEnabled(logger)
        logger.thresholdLevel = loggerSettings.loggerLevel(logger)
        logger.synchronous = true
        return logger
        }()

}
