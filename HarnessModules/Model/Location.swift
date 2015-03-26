//
//  Location.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/23/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import CoreLocation
import Foundation

private let kLocationTitleKey = "title"
private let kLocationSubtitleKey = "subtitle"
private let kLocationNicknameKey = "nickname"
private let kLocationLatitudeKey = "latitude"
private let kLocationLongitudeKey = "longitude"
private let kLocationImageUrlKey = "imageUrl"

public class Location: ModelObject {
   
    // MARK:- Properties
    
    private(set) public var title = ""
    private(set) public var subtitle = ""
    private(set) public var nickname: String?
    private(set) public var latitude = CLLocationDegrees(0.0)
    private(set) public var longitude = CLLocationDegrees(0.0)
    private(set) public var imageUrl: String?

}

public let kLocationTitleApiKeyPath = "title"
public let kLocationSubtitleApiKeyPath = "subtitle"
public let kLocationNicknameApiKeyPath = "nickname"
public let kLocationLatitudeApiKeyPath = "latitude"
public let kLocationLongitudeApiKeyPath = "longitude"
public let kLocationImageUrlApiKeyPath = "image_url"

public class LocationAPIMapper: ModelObjectAPIMapper {
    
    // MARK:- Constructor
    
    public override init(apiFieldMappers: [ APIFieldMapper] = [APIFieldMapper ](), delegate: APIMapperDelegate) {
        super.init(apiFieldMappers: apiFieldMappers, delegate: delegate)
        var apiFieldMappers = super.apiFieldMappers
        apiFieldMappers += [
            delegate.fieldMapper(apiKeyPath: kLocationTitleApiKeyPath, modelKey: kLocationTitleKey),
            delegate.fieldMapper(apiKeyPath: kLocationSubtitleApiKeyPath, modelKey: kLocationSubtitleKey),
            delegate.fieldMapper(apiKeyPath: kLocationNicknameApiKeyPath, modelKey: kLocationNicknameKey, required: false),
            delegate.fieldMapper(apiKeyPath: kLocationLatitudeApiKeyPath, modelKey: kLocationLatitudeKey),
            delegate.fieldMapper(apiKeyPath: kLocationLongitudeApiKeyPath, modelKey: kLocationLongitudeKey),
            delegate.fieldMapper(apiKeyPath: kLocationImageUrlApiKeyPath, modelKey: kLocationImageUrlKey)
        ]
        self.apiFieldMappers = apiFieldMappers
    }
    
}
