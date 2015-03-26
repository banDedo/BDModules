//
//  TripAPIMapperTests.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import CoreLocation
import Foundation
import XCTest

class TripAPIMapperTests: XCTestCase {

    // MARK:- Properties

    var jsonSerializer = JSONSerializer()
    var mockModelFactory = MockModelFactory()
    lazy var tripAPIMapper: TripAPIMapper = { return TripAPIMapper(delegate: self.mockModelFactory) }()
    
    // MARK:- Setup

    override func setUp() {
        super.setUp()
        
        jsonSerializer = JSONSerializer()
        mockModelFactory = MockModelFactory()
        tripAPIMapper = TripAPIMapper(delegate: self.mockModelFactory)
    }
    
    // MARK:- Tests

    func testParseTrip() {
        let dictionary = jsonSerializer.object(
            resourceName: "trip_stub",
            bundle: NSBundle(forClass: Trip.self)) as! NSDictionary
        
        let tripDictionary = dictionary["data"] as! NSDictionary
        
        let trip = Trip(dictionary: tripDictionary)
        tripAPIMapper.map(tripDictionary, object: trip)

        XCTAssertEqual(trip.profile.dictionary, tripDictionary[kTripProfileApiKeyPath] as! NSDictionary)
        XCTAssertEqual(trip.startLocation.dictionary, tripDictionary[kTripStartLocationApiKeyPath] as! NSDictionary)
        XCTAssertEqual(trip.endLocation.dictionary, tripDictionary[kTripEndLocationApiKeyPath] as! NSDictionary)
    }
    
}
