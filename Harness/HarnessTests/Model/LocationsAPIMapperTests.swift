//
//  LocationsAPIMapperTests.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import CoreLocation
import Foundation
import XCTest

class LocationsAPIMapperTests: XCTestCase {

    // MARK:- Properties

    var jsonSerializer = JSONSerializer()
    var mockModelFactory = MockModelFactory()
    lazy var locationAPIMapper: LocationAPIMapper = { return LocationAPIMapper(delegate: self.mockModelFactory) }()
    
    // MARK:- Setup

    override func setUp() {
        super.setUp()
        
        jsonSerializer = JSONSerializer()
        mockModelFactory = MockModelFactory()
        locationAPIMapper = LocationAPIMapper(delegate: self.mockModelFactory)
    }
    
    // MARK:- Tests

    func testParseLocation() {
        let dictionary = jsonSerializer.object(
            resourceName: "favorite_locations_stub",
            bundle: NSBundle(forClass: Location.self)) as! NSDictionary
        
        let locationDictionary = (dictionary["data"] as! NSArray)[1] as! NSDictionary
        
        let location = Location(dictionary: locationDictionary)
        locationAPIMapper.map(locationDictionary, object: location)

        XCTAssertEqual(location.title, locationDictionary[kLocationTitleApiKeyPath] as! String)
        XCTAssertEqual(location.subtitle, locationDictionary[kLocationSubtitleApiKeyPath] as! String)
        XCTAssertEqual(location.nickname!, locationDictionary[kLocationNicknameApiKeyPath] as! String)
        XCTAssertEqual(location.latitude, locationDictionary[kLocationLatitudeApiKeyPath] as! CLLocationDegrees)
        XCTAssertEqual(location.longitude, locationDictionary[kLocationLongitudeApiKeyPath] as! CLLocationDegrees)
    }
    
}
