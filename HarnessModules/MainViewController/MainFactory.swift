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

    // MARK:- View Controllers

    public func mainViewController(#delegate: MainViewControllerDelegate) -> MainViewController {
        let mainViewController = MainViewController()
        mainViewController.mapViewController = mapViewController(delegate: mainViewController)
        mainViewController.delegate = delegate
        return mainViewController
    }
    
    public func mapViewController(#delegate: MapViewControllerDelegate) -> MapViewController {
        let mapViewController = MapViewController()
        mapViewController.mainFactory = self
        mapViewController.accountUserProvider = apiFactory.accountUserProvider
        mapViewController.locationManager = locationManager(delegate: mapViewController)
        mapViewController.locationRepository = apiFactory.locationRepository(apiFactory.accountUserProvider.user.uuid)
        mapViewController.oAuth2SessionManager = apiFactory.oAuth2SessionManager()
        mapViewController.delegate = delegate
        return mapViewController
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
