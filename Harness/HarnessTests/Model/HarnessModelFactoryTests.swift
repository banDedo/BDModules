//
//  HarnessModelFactoryTests.swift
//  Harness
//
//  Created by Patrick Hogan on 3/12/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation
import XCTest

class HarnessModelFactoryTests: XCTestCase {

    // MARK:- Properties
    
    let jsonSerializer = JSONSerializer()
    lazy var modelFactory = ModelFactory()
    
    // MARK:- Setup
    
    override func setUp() {
        super.setUp()
        modelFactory = ModelFactory()
        modelFactory.objectMapperPair = ModelFactoryMapper.objectMapperPair(modelFactory)
    }
 
    // MARK:- Tests

    func testParseUser() {
        let dictionary = jsonSerializer.object(
            resourceName: "me_stub",
            bundle: NSBundle(forClass: User.self)) as! NSDictionary
        
        let user = modelFactory.defaultObjectParser(dictionary)
        XCTAssert(user.isKindOfClass(User.self))
    }
    
    func testParseLocations() {
        let dictionary = jsonSerializer.object(
            resourceName: "favorite_locations_stub",
            bundle: NSBundle(forClass: Location.self)) as! NSDictionary
        
        let locations = modelFactory.defaultCollectionParser(dictionary)
        XCTAssertEqual(locations.count, 2)
        XCTAssert(locations.first!.isKindOfClass(Location.self))
        XCTAssert(locations.last!.isKindOfClass(Location.self))
    }
    
}
