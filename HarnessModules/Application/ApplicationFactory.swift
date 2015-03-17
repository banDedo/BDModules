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
        apiFactory.configureOAuth2Properties()

        // EntryFactory
        
        entryFactory.apiFactory = apiFactory
        
        // MainFactory
        
        mainFactory.apiFactory = apiFactory

    }
    
    // MARK:- Initial injection

    public func inject(appDelegate: AppDelegate) {
        appDelegate.appLifecycleLogger = logger
        appDelegate.rootViewController = rootViewController()
    }

    // MARK:- Application
    
    public lazy var logger: Logger = {
        let logger = Logger(tag: "Application Lifecycle", applicationName: "BDModules")
        logger.enabled = true
        logger.synchronous = true
        logger.thresholdLevel = .Verbose
        return logger
        }()

    // MARK:- ModelFactory

    public lazy var modelLogger: Logger = {
        let logger = Logger(tag: "Model", applicationName: "BDModules")
        logger.enabled = true
        logger.synchronous = true
        logger.thresholdLevel = .Warning
        return logger
        }()

}
