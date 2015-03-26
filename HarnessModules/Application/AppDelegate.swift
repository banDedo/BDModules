//
//  AppDelegate.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/20/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK:- Injectable
    
    public lazy var appLifecycleLogger = Logger()
    public lazy var rootViewController: RootViewController = RootViewController()

    // MARK:- Properties

    public let applicationFactory = ApplicationFactory()
    public var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    // MARK:- Application Lifecycle

    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        applicationFactory.inject(self)
        
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        NavigationBar.configure()
        
        appLifecycleLogger.logVerbose("Application did finish launching")

        return true
    }

    public func applicationDidBecomeActive(application: UIApplication) {
        appLifecycleLogger.logVerbose("Application did become active")
    }
    
    public func applicationWillResignActive(application: UIApplication) {
        appLifecycleLogger.logVerbose("Application will resign active")
    }
    
    public func applicationWillEnterForeground(application: UIApplication) {
        appLifecycleLogger.logVerbose("Application will enter foreground")
    }
    
    public func applicationDidEnterBackground(application: UIApplication) {
        appLifecycleLogger.logVerbose("Application did enter background")
    }
    
    public func applicationWillTerminate(application: UIApplication) {
        appLifecycleLogger.logVerbose("Application will terminate")
    }

}
