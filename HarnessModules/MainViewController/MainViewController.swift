//
//  MainViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

@objc public protocol MainViewControllerDelegate: class {
    func mainViewControllerDidLogout(mainViewController: MainViewController)
}

public class MainViewController: LifecycleViewController, MapViewControllerDelegate {

    // MARK:- Injectable
    
    public lazy var mapViewController = MapViewController()

    weak public var delegate: MainViewControllerDelegate?
    
    // MARK:- Properties
    
    public lazy var mainNavigationController: NavigationController = {
        let mainNavigationController = NavigationController()
        mainNavigationController.viewControllers = [ self.mapViewController ]
        return mainNavigationController
        }()

    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        replaceRootViewController(mainNavigationController)
    }
    
    // MARK:- MapViewControllerDelegate
    
    public func mapViewControllerDidLogout(mapViewController: MapViewController) {
        delegate?.mainViewControllerDidLogout(self)
    }
    
}
