//
//  Trip.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/23/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation

private let kTripProfileKey = "profile"
private let kTripStartLocationKey = "startLocation"
private let kTripEndLocationKey = "endLocation"

public class Trip: ModelObject {
    
    // MARK:- Properties
    
    private(set) public var profile: Profile = User(dictionary: NSDictionary())
    private(set) public var startLocation = Location(dictionary: NSDictionary())
    private(set) public var endLocation = Location(dictionary: NSDictionary())
    
}

public let kTripProfileApiKeyPath = "profile"
public let kTripStartLocationApiKeyPath = "start_location"
public let kTripEndLocationApiKeyPath = "end_location"

public class TripAPIMapper: ModelObjectAPIMapper {
    
    // MARK:- Constructor
    
    public override init(apiFieldMappers: [ APIFieldMapper] = [APIFieldMapper ](), delegate: APIMapperDelegate) {
        super.init(apiFieldMappers: apiFieldMappers, delegate: delegate)
        var apiFieldMappers = super.apiFieldMappers
        apiFieldMappers += [
            delegate.fieldMapper(apiKeyPath: kTripProfileApiKeyPath, modelKey: kTripProfileKey, type: .ValueObject),
            delegate.fieldMapper(apiKeyPath: kTripStartLocationApiKeyPath, modelKey: kTripStartLocationKey, type: .ValueObject),
            delegate.fieldMapper(apiKeyPath: kTripEndLocationApiKeyPath, modelKey: kTripEndLocationKey, type: .ValueObject)
        ]
        self.apiFieldMappers = apiFieldMappers
    }
    
}
