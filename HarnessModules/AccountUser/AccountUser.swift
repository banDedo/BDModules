//
//  AccountUser.swift
//  BDModules
//
//  Created by Patrick Hogan on 12/2/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import BDModules
import Foundation

private let kAccountUserUserKey = "user"
private let kAccountUserOAuth2CredentialKey = "oAuth2Credential"

public class AccountUser: NSObject, NSCoding {
   
    // MARK:- Properties
    
    public var user: User?
    public var oAuth2Credential: OAuth2Credential?

    // MARK:- Constructor

    public override init() {
        super.init()
    }

    // MARK:- NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        user = aDecoder.decodeObjectForKey(kAccountUserUserKey) as? User
        oAuth2Credential = aDecoder.decodeObjectForKey(kAccountUserOAuth2CredentialKey) as? OAuth2Credential
        super.init()
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(user, forKey: kAccountUserUserKey)
        aCoder.encodeObject(oAuth2Credential, forKey: kAccountUserOAuth2CredentialKey)
    }

}
