//
//  APIResource.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/23/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation

public enum APIResource: String {
   
    case Users = "/users"
    case Locations = "/locations"
    case Trips = "/trips"

    // MARK: - Paths

    public func path() -> String {
        return rawValue
    }
    
    public func path(#uuid: String) -> String {
        return "\(rawValue)/\(uuid)"
    }

    public static func userLocationsPath(
        #userUuid: String,
        locationUuid: String? = nil) -> String {
            return resourcePath(
                base: self.Users.path(uuid: userUuid),
                resourceType: .Locations,
                uuid: locationUuid
            )
    }

    public static func userTripsPath(
        #userUuid: String,
        tripUuid: String? = nil) -> String {
            return resourcePath(
                base: self.Users.path(uuid: userUuid),
                resourceType: .Trips,
                uuid: tripUuid
            )
    }

    public static func userCurrentTripPath(
        #userUuid: String) -> String {
            return userTripsPath(userUuid: userUuid).stringByAppendingPathComponent("/current")
    }

    // MARK: - Private path
    
    private static func path(
        #base: String,
        resource: APIResource,
        uuid: String?) -> String {
            return base + ((uuid == nil) ? "\(resource.path())" : "\(resource.path(uuid: uuid!))")
    }
    
    private static func resourcePath(
        #base: String,
        resourceType: APIResource,
        uuid: String?) -> String {
            return base + ((uuid == nil) ? "\(resourceType.path())" : "\(resourceType.path(uuid: uuid!))")
    }
    
}
