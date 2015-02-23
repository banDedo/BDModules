//
//  EntryFactory.swift
//  BDModules
//
//  Created by Patrick Hogan on 3/1/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public class EntryFactory: NSObject {
   
    // MARK:- Injectable

    public lazy var apiFactory = APIFactory()

    // MARK:- View Controllers

    public func entryViewController(#delegate: EntryViewControllerDelegate) -> EntryViewController {
        let entryViewController = EntryViewController()
        entryViewController.landingViewController = landingViewController(delegate: entryViewController)
        entryViewController.delegate = delegate
        return entryViewController
    }
    
    public func landingViewController(#delegate: LandingViewControllerDelegate) -> LandingViewController {
        let landingViewController = LandingViewController()
        landingViewController.accountUserProvider = apiFactory.accountUserProvider
        landingViewController.userAPI = apiFactory.userAPI()
        landingViewController.delegate = delegate
        return landingViewController
    }
    
}
