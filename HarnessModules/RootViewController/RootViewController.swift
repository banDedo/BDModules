//
//  RootViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class RootViewController: LifecycleViewController, EntryViewControllerDelegate, MainViewControllerDelegate {
    
    // MARK:- Injectable
    
    lazy var accountUserProvider = AccountUserProvider()
    lazy var mainFactory = MainFactory()
    lazy var entryFactory = EntryFactory()
    
    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = accountUserProvider.accountUser.user {
            presentMainViewController()
        } else {
            presentEntryController()
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK:- Child view controllers
    
    public func presentEntryController(animated: Bool = false) {
        logoutAccountUser()
        replaceRootViewController(entryFactory.entryViewController(delegate: self), animated: animated)
    }
    
    public func presentMainViewController(animated: Bool = false) {
        replaceRootViewController(mainFactory.mainViewController(delegate: self), animated: animated)
    }
    
    // MARK:- Status Bar Style
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let rootViewController = self.rootViewController {
            if let presentedViewController = rootViewController.presentedViewController,
                viewController = (presentedViewController as? UINavigationController)?.topViewController,
                lifecycleState = (viewController as? LifecycleViewController)?.lifecycleState {
                    if lifecycleState == .Disappearing || lifecycleState == .Disappeared {
                        return rootViewController.preferredStatusBarStyle()
                    }
                    return presentedViewController.preferredStatusBarStyle()
            } else {
                return rootViewController.preferredStatusBarStyle()
            }
        } else {
            return UIStatusBarStyle.LightContent
        }
    }
    
    // MARK:- Logout
    
    public func logoutAccountUser() {
        accountUserProvider.logout()
    }
    
    // MARK:- LoginViewControllerDelegate
        
    public func entryViewControllerDidLogin(entryViewController: EntryViewController) {
        presentMainViewController(animated: true)
    }
    
    // MARK:- MainViewControllerDelegate
    
    public func mainViewControllerDidLogout(mainViewController: MainViewController) {
        presentEntryController(animated: true)
    }
    
}
