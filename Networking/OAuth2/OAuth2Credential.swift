//
//  OAuth2Credential.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/5/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

private let kOAuth2AccessTokenKey = "accessToken"
private let kOAuth2RefreshTokenKey = "refreshToken"

public class OAuth2Credential: NSObject, NSCoding {
    
    // MARK:- Public Properties
    
    public let accessToken: String
    public let refreshToken: String
        
    // MARK:- Constructor

    public init(accessToken anAccessToken: String, refreshToken aRefreshToken: String) {
        accessToken = anAccessToken
        refreshToken = aRefreshToken
        super.init()
    }
    
    // MARK:- NSCoding

    public required init(coder aDecoder: NSCoder) {
        accessToken = (aDecoder.decodeObjectForKey(kOAuth2AccessTokenKey) as? String)!
        refreshToken = (aDecoder.decodeObjectForKey(kOAuth2RefreshTokenKey) as? String)!
        super.init()
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(accessToken, forKey: kOAuth2AccessTokenKey)
        coder.encodeObject(refreshToken, forKey: kOAuth2RefreshTokenKey)
    }
    
}
