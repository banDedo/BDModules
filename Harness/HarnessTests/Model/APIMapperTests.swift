//
//  APIMapperTests.swift
//  Harness
//
//  Created by Patrick Hogan on 3/15/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation
import XCTest

// MARK:- Fixtures

class NullFieldModelObject: ModelObject {
    var nullField: String?
}

class ContainerModelObject: ModelObject {
    var modelObject = ModelObject(dictionary: NSDictionary())
}

class CollectionContainerModelObject: ModelObject {
    var modelObjects = [ ModelObject ]()
}

class APIMapperTests: XCTestCase {

    // MARK:- Properties

    lazy var mockModelFactory = MockModelFactory()
    
    // MARK:- Setup
    
    override func setUp() {
        super.setUp()
        mockModelFactory = MockModelFactory()
    }
    
    // MARK:- Missing Field

    func testSuccessfullyParsesNullField() {
        testSuccessfullyParsesEmptyField(true)
    }
    
    func testSuccessfullyParsesMissingField() {
        testSuccessfullyParsesEmptyField(false)
    }

    func testSuccessfullyParsesEmptyField(isNull: Bool) {
        var additionalApiFieldMappers = [
            APIFieldMapper(apiKeyPath: "null_field", modelKey: "nullField", required: false, type: .Default)
        ]
        
        let uuid = "123"
        let pagingId = "abc"
        var dictionary = mockModelFactory.modelResponseObject(uuid, pagingId) as! [ String: AnyObject ]
        if isNull {
            dictionary += [ "null_field":  NSNull() ]
        }
        
        var apiMapper = ModelObjectAPIMapper(apiFieldMappers: additionalApiFieldMappers, delegate: mockModelFactory)
        
        let nullFieldModelObject = NullFieldModelObject(dictionary: dictionary)
        apiMapper.map(dictionary, object: nullFieldModelObject)
        
        XCTAssertEqual(uuid, nullFieldModelObject.uuid)
        XCTAssertEqual(pagingId, nullFieldModelObject.pagingId!)
        XCTAssertNil(nullFieldModelObject.nullField)
    }

    // MARK:- Container

    func testSuccessfullyParsesContainer() {
        var additionalApiFieldMappers = [
            APIFieldMapper(apiKeyPath: "model_object", modelKey: "modelObject", required: false, type: .ValueObject)
        ]
        
        let uuid = "123"
        let pagingId = "abc"
        var dictionary = mockModelFactory.modelResponseObject(uuid, pagingId) as! [ String: AnyObject ]

        let containedUuid = "456"
        let containedPagingId = "def"
        var containedDictionary = mockModelFactory.modelResponseObject(containedUuid, containedPagingId) as! [ String: AnyObject ]
        dictionary += [ "model_object":  containedDictionary ]
        
        var apiMapper = ModelObjectAPIMapper(apiFieldMappers: additionalApiFieldMappers, delegate: mockModelFactory)
        
        let containerModelObject = ContainerModelObject(dictionary: dictionary)
        apiMapper.map(dictionary, object: containerModelObject)
        
        XCTAssertEqual(uuid, containerModelObject.uuid)
        XCTAssertEqual(pagingId, containerModelObject.pagingId!)
        XCTAssertEqual(containerModelObject.modelObject.uuid, containedUuid)
        XCTAssertEqual(containerModelObject.modelObject.pagingId!, containedPagingId)
    }

    // MARK:- Collection Container

    func testSuccessfullyParsesCollectionContainer() {
        var additionalApiFieldMappers = [
            APIFieldMapper(apiKeyPath: "model_objects", modelKey: "modelObjects", required: false, type: .ValueArray)
        ]
        
        let uuid = "123"
        let pagingId = "abc"
        var dictionary = mockModelFactory.modelResponseObject(uuid, pagingId) as! [ String: AnyObject ]
        
        let firstContainedUuid = "456"
        let firstContainedPagingId = "def"
        var firstContainedDictionary = mockModelFactory.modelResponseObject(firstContainedUuid, firstContainedPagingId) as! [ String: AnyObject ]

        let secondContainedUuid = "789"
        let secondContainedPagingId = "ghi"
        var secondContainedDictionary = mockModelFactory.modelResponseObject(secondContainedUuid, secondContainedPagingId) as! [ String: AnyObject ]
        
        dictionary += [ "model_objects":  [ firstContainedDictionary, secondContainedDictionary ] ]
        
        var apiMapper = ModelObjectAPIMapper(apiFieldMappers: additionalApiFieldMappers, delegate: mockModelFactory)
        
        let collectionContainerModelObject = CollectionContainerModelObject(dictionary: dictionary)
        apiMapper.map(dictionary, object: collectionContainerModelObject)
        
        XCTAssertEqual(uuid, collectionContainerModelObject.uuid)
        XCTAssertEqual(pagingId, collectionContainerModelObject.pagingId!)
        
        XCTAssertEqual(collectionContainerModelObject.modelObjects.count, 2)
        
        XCTAssertEqual(collectionContainerModelObject.modelObjects.first!.uuid, firstContainedUuid)
        XCTAssertEqual(collectionContainerModelObject.modelObjects.first!.pagingId!, firstContainedPagingId)
        
        XCTAssertEqual(collectionContainerModelObject.modelObjects.last!.uuid, secondContainedUuid)
        XCTAssertEqual(collectionContainerModelObject.modelObjects.last!.pagingId!, secondContainedPagingId)
    }

}
