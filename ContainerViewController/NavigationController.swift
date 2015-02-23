//
//  NavigationController.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/22/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public class NavigationController: UINavigationController {

    // MARK:- Status Bar Style
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return topViewController.preferredStatusBarStyle()
    }
    
}
