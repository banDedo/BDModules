//
//  User.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/23/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation

private let kUserFirstNameKey = "firstName"
private let kUserLastNameKey = "lastName"
private let kUserEmailKey = "email"
private let kUserPhoneNumberKey = "phoneNumber"
private let kUserCoverImageURLKey = "coverImageURL"
private let kUserProfileImageURLKey = "profileImageURL"

public class User: ModelObject, UserProfile {
   
    // MARK:- Properties
    
    private(set) public var firstName = ""
    private(set) public var lastName = ""
    private(set) public var email = ""
    private(set) public var phoneNumber: String?
    private(set) public var coverImageURL: String?
    private(set) public var profileImageURL: String?
    
    public var displayName: String {
        get {
            return firstName + " " + lastName
        }
    }

}

public let kUserFirstNameApiKeyPath = "first_name"
public let kUserLastNameApiKeyPath = "last_name"
public let kUserEmailApiKeyPath = "email"
public let kUserPhoneNumberApiKeyPath = "phone_number"
public let kUserCoverImageURLApiKeyPath = "cover_image_url"
public let kUserProfileImageURLApiKeyPath = "profile_image_url"

public class UserAPIMapper: ModelObjectAPIMapper {
    
    // MARK:- Constructor
    
    public override init(apiFieldMappers: [ APIFieldMapper] = [APIFieldMapper ](), delegate: APIMapperDelegate) {
        super.init(apiFieldMappers: apiFieldMappers, delegate: delegate)
        var apiFieldMappers = super.apiFieldMappers
        apiFieldMappers += [
            delegate.fieldMapper(apiKeyPath: kUserFirstNameApiKeyPath, modelKey: kUserFirstNameKey),
            delegate.fieldMapper(apiKeyPath: kUserLastNameApiKeyPath, modelKey: kUserLastNameKey),
            delegate.fieldMapper(apiKeyPath: kUserEmailApiKeyPath, modelKey: kUserEmailKey),
            delegate.fieldMapper(apiKeyPath: kUserPhoneNumberApiKeyPath, modelKey: kUserPhoneNumberKey, required: false),
            delegate.fieldMapper(apiKeyPath: kUserCoverImageURLApiKeyPath, modelKey: kUserCoverImageURLKey, required: false),
            delegate.fieldMapper(apiKeyPath: kUserProfileImageURLApiKeyPath, modelKey: kUserProfileImageURLKey, required: false),
        ]
        self.apiFieldMappers = apiFieldMappers
    }
    
}
