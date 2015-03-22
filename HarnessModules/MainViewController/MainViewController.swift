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

public class MainViewController: LifecycleViewController, FavoritesViewControllerDelegate, MapViewControllerDelegate, MenuViewControllerDelegate {

    // MARK:- Injectable
    
    public lazy var menuViewController = MenuViewController()
    public lazy var mainFactory = MainFactory()

    weak public var delegate: MainViewControllerDelegate?
    
    // MARK:- Properties
        
    public lazy var navigationDrawerViewController: NavigationDrawerViewController = {
        let navigationDrawerViewController = NavigationDrawerViewController()
        navigationDrawerViewController.statusBarBlockerView.backgroundColor = Color.deepBlueColor
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
        return self.mainNavigationController(self.mainFactory.mapViewController(delegate: self))
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
    
    // MARK:- Main Navigation Controller
    
    private func mainNavigationController(rootViewController: LifecycleViewController) -> NavigationController {
        let mainNavigationController = NavigationController()
        mainNavigationController.viewControllers = [ rootViewController ]
        return mainNavigationController
    }

    // MARK:- Menu
    
    private func updateMenu() {
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
    
    // MARK:- FavoriteLocationsViewControllerDelegate
    
    public func favoritesViewController(favoritesViewController: FavoritesViewController, didTapMenuButton sender: UIButton) {
        updateMenu()
    }

    // MARK:- MapViewControllerDelegate

    public func mapViewController(mapViewController: MapViewController, didTapMenuButton sender: UIButton) {
        updateMenu()
    }

    // MARK:- MenuViewControllerDelegate

    public func menuViewController(menuViewController: MenuViewController, didSelectRow row: MenuViewController.Row) {
        switch row {
        case .Map:
            navigationDrawerViewController.replaceCenterViewController({
                return self.mainNavigationController(self.mainFactory.mapViewController(delegate: self))
                },
                animated: true)
            break
        case .Favorites:
            navigationDrawerViewController.replaceCenterViewController({
                return self.mainNavigationController(self.mainFactory.favoritesViewController(delegate: self))
                },
                animated: true)
            break
        case .Logout:
            delegate?.mainViewControllerDidLogout(self)
            break
        case .Footer:
            break
        }
    }
    
}
