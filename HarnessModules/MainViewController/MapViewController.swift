//
//  MapViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/11/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import MapKit
import UIKit

public class MapViewController: LifecycleViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK:- Injectable
    
    public lazy var accountUserProvider = AccountUserProvider()
    public lazy var locationRepository = Repository<Location>()
    public lazy var oAuth2SessionManager = OAuth2SessionManager()
    public lazy var mainFactory = MainFactory()
    public lazy var locationManager = CLLocationManager()
    public lazy var userDefaults = UserDefaults()
    
    weak public var delegate: MenuNavigationControllerDelegate?
    
    // MARK:- Properties
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: CGRectZero)
        mapView.delegate = self
        mapView.showsUserLocation = true
        return mapView
        }()
    
    // MARK:- Cleanup
    
    deinit {
        locationManager.delegate = nil
        mapView.delegate = nil
    }

    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "On Trip"
        
        view.addSubview(mapView)
                
        mapView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        if let location = userDefaults.lastUserLocation {
            zoomToCoordinate(
                CLLocationCoordinate2DMake(
                    location[kUserDefaultsLastUserLocationLatitudeKey] as! CLLocationDegrees,
                    location[kUserDefaultsLastUserLocationLongitudeKey] as! CLLocationDegrees
                ),
                animated: false
            )
        }
        
        locationRepository.fetch() { [weak self] locations, error in
            if let strongSelf = self {
                if error != nil {
                    let alertController = UIAlertController(
                        title: "Error",
                        message: error!.description,
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    
                    alertController.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: UIAlertActionStyle.Cancel) { action in
                                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                        }
                    )
                    
                    strongSelf.presentViewController(alertController, animated: true, completion: nil)
                }
                strongSelf.updateUI()
            }
        }
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBar.addMenuButton(target: self, action: "handleButtonTap:")
    }
    
    // MARK:- UI Update
    
    public func updateUI() {
        switch locationRepository.fetchState {
        case .NotFetched:
            break
        case .Fetching:
            break
        case .Fetched:
            for location in locationRepository.elements {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                annotation.title = location.title
                annotation.subtitle = location.subtitle
                mapView.addAnnotation(annotation)
            }
            break
        case .Error:
            break
        }
    }
    
    // MARK:- Action Handlers
    
    public func handleButtonTap(sender: UIButton) {
        delegate?.viewController(self, didTapMenuButton: sender)
    }
    
    // MARK:- Status Bar
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    private func zoomToCoordinate(coordinate: CLLocationCoordinate2D, animated: Bool = false) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 5000.0, 5000.0)
        mapView.setRegion(region, animated: animated)
    }

    // MARK:- CLLocationManagerDelegate
    
    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Error",
                message: "Enable location access through phone settings menu.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            alertController.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.Cancel) { action in
                        self.dismissViewControllerAnimated(true, completion: nil)
                }
            )
            
            presentViewController(alertController, animated: true, completion: nil)
            break
        case .NotDetermined:
            break
        }
    }
    
    // MARK:- MKMapViewDelegate
    
    public func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        zoomToCoordinate(userLocation.coordinate, animated: true)
        userDefaults.lastUserLocation = [
            kUserDefaultsLastUserLocationLatitudeKey: userLocation.coordinate.latitude,
            kUserDefaultsLastUserLocationLongitudeKey: userLocation.coordinate.longitude
        ]
    }
    
}
