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

public class MainViewController: LifecycleViewController, MapViewControllerDelegate, MenuViewControllerDelegate {

    // MARK:- Injectable
    
    public lazy var menuViewController = MenuViewController()
    public lazy var mapViewController = MapViewController()

    weak public var delegate: MainViewControllerDelegate?
    
    // MARK:- Properties
        
    public lazy var navigationDrawerViewController: NavigationDrawerViewController = {
        let navigationDrawerViewController = NavigationDrawerViewController()
        navigationDrawerViewController.replaceLeftViewController(self.menuNavigationController)
        navigationDrawerViewController.replaceCenterViewController(self.mainNavigationController)
        return navigationDrawerViewController
        }()

    public lazy var menuNavigationController: NavigationController = {
        let menuNavigationController = NavigationController()
        menuNavigationController.setNavigationBarHidden(true, animated: false)
        menuNavigationController.viewControllers = [ self.menuViewController ]
        return menuNavigationController
        }()

    public lazy var mainNavigationController: NavigationController = {
        let mainNavigationController = NavigationController()
        mainNavigationController.viewControllers = [ self.mapViewController ]
        return mainNavigationController
        }()

    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        replaceRootViewController(navigationDrawerViewController)
    }

    // MARK:- Status bar
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        switch navigationDrawerViewController.orientation {
        case .Default:
            return mainNavigationController.preferredStatusBarStyle()
        case .PartialRevealLeft, .RevealLeft:
            return menuViewController.preferredStatusBarStyle()
        }
    }

    // MARK:- MapViewControllerDelegate

    public func mapViewController(mapViewController: MapViewController, didTapMenuButton sender: UIButton) {
        let orientation: NavigationDrawerViewController.Orientation
        switch navigationDrawerViewController.orientation {
        case .Default:
            orientation = .PartialRevealLeft
            break
        case .PartialRevealLeft, .RevealLeft:
            orientation = .Default
            break
        }
        
        navigationDrawerViewController.anchorDrawer(
            orientation,
            animated: true
        )
    }

    public func menuViewController(menuViewController: MenuViewController, didTapLogoutCell: MenuCell) {
        delegate?.mainViewControllerDidLogout(self)
    }
    
}
