//
//  MainFactory.swift
//  BDModules
//
//  Created by Patrick Hogan on 3/1/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import CoreLocation
import UIKit

public class MainFactory: NSObject {
   
    // MARK:- Injectable
    
    public lazy var apiFactory = APIFactory()
    public lazy var applicationFactory = ApplicationFactory()
    public lazy var jsonFactory = JSONFactory()

    // MARK:- View Controllers

    public func favoritesViewController(#delegate: MenuNavigationControllerDelegate) -> FavoritesViewController {
        let animatedImageView = MockAnimatedImageView()
        var backgroundImages = [ UIImage ]()
        for i in 0..<10 {
            backgroundImages.append(UIImage(named: "\(i).png")!)
        }
        animatedImageView.images = backgroundImages

        let favoritesViewController = FavoritesViewController()
        favoritesViewController.accountUserProvider = apiFactory.accountUserProvider
        favoritesViewController.animatedImageView = animatedImageView
        favoritesViewController.favoriteLocationRepository = apiFactory.favoriteLocationRepository(apiFactory.accountUserProvider.user.uuid)
        favoritesViewController.mainFactory = self
        favoritesViewController.oAuth2SessionManager = apiFactory.oAuth2SessionManager()
        favoritesViewController.delegate = delegate
        return favoritesViewController
    }

    public func mainViewController(#delegate: MainViewControllerDelegate) -> MainViewController {
        let mainViewController = MainViewController()
        mainViewController.menuViewController = menuViewController(mainViewController)
        mainViewController.mainFactory = self
        mainViewController.delegate = delegate
        return mainViewController
    }
    
    public func mapViewController(#delegate: MenuNavigationControllerDelegate) -> MapViewController {
        let mapViewController = MapViewController()
        mapViewController.mainFactory = self
        mapViewController.accountUserProvider = apiFactory.accountUserProvider
        mapViewController.locationManager = locationManager(delegate: mapViewController)
        mapViewController.locationRepository = apiFactory.mapLocationRepository(apiFactory.accountUserProvider.user.uuid)
        mapViewController.oAuth2SessionManager = apiFactory.oAuth2SessionManager()
        mapViewController.userDefaults = apiFactory.userDefaults
        mapViewController.delegate = delegate
        return mapViewController
    }

    public func menuViewController(delegate: MenuViewControllerDelegate) -> MenuViewController {
        let animatedImageView = MockAnimatedImageView()
        animatedImageView.images = [ UIImage(named: "profile_image.png")! ]
        
        let menuViewController = MenuViewController()
        menuViewController.accountUserProvider = apiFactory.accountUserProvider
        menuViewController.animatedImageView = animatedImageView
        menuViewController.delegate = delegate
        return menuViewController
    }

    public func settingsViewController(#delegate: MenuNavigationControllerDelegate) -> SettingsViewController {
        let settingsViewController = SettingsViewController()
        settingsViewController.accountUserProvider = apiFactory.accountUserProvider
        settingsViewController.applicationLifecycleLogger = applicationFactory.logger
        settingsViewController.apiLogger = apiFactory.logger
        settingsViewController.jsonLogger = jsonFactory.logger
        settingsViewController.modelLogger = applicationFactory.modelLogger
        settingsViewController.userDefaults = apiFactory.userDefaults
        settingsViewController.delegate = delegate
        return settingsViewController
    }

    // MARK: - Location
    
    private lazy var locationManager = CLLocationManager()

    public func locationManager(#delegate: CLLocationManagerDelegate) -> CLLocationManager {
        let locationManager = self.locationManager
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }

}
