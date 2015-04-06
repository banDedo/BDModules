//
//  EntryViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 3/1/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public protocol EntryViewControllerDelegate: class {
    func entryViewControllerDidLogin(entryViewController: EntryViewController)
}

public class EntryViewController: LifecycleViewController, LandingViewControllerDelegate {
    
    // MARK:- Injectable
    
    public lazy var landingViewController = LandingViewController()

    weak public var delegate: EntryViewControllerDelegate?

    // MARK:- Public properties

    public lazy var entryNavigationController: NavigationController = {
        let entryNavigationController = NavigationController()
        entryNavigationController.setNavigationBarHidden(true, animated: false)
        entryNavigationController.viewControllers = [ self.landingViewController ]
        return entryNavigationController
        }()
    
    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        replaceRootViewController(entryNavigationController)
    }
    
    // MARK:- Status bar
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return entryNavigationController.preferredStatusBarStyle()
    }

    // MARK:- LandingViewControllerDelegate
    
    public func landingViewControllerDidLogin(landingViewController: LandingViewController) {
        delegate?.entryViewControllerDidLogin(self)
    }
    
}
