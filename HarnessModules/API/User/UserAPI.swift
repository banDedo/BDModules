//
//  UserAPI.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/20/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation

public class UserAPI {
    
    // MARK:- Injectable
    
    public lazy var accountUserProvider = AccountUserProvider()
    public lazy var oAuth2SessionManager = OAuth2SessionManager()
    public lazy var userServiceClient = APIServiceClient<User>()
    
    public func login(
        #email: String,
        password: String,
        userPersistenceHandler: User -> Void,
        handler: ((User?, NSError?) -> Void)) {
            oAuth2SessionManager.tokenGrant(
                username: email,
                password: password) { [weak self] URLSessionDataTask, responseObject, error in
                    if let strongSelf = self {
                        if error != nil {
                            handler(nil, error)
                        } else {
                            strongSelf.me(userPersistenceHandler, handler: handler)
                        }
                    }
            }
    }
    
    public func me(
        userPersistenceHandler: User -> Void,
        handler: ((User?, NSError?) -> Void)) {
            userServiceClient.performRequest(
                method: .GET,
                path: APIResource.Users.path().stringByAppendingPathComponent("/me")) { [weak self] user, error in
                    if let strongSelf = self {
                        if error != nil {
                            handler(nil, error)
                        } else {
                            userPersistenceHandler(user!)
                            handler(user, nil)
                        }
                    }
            }
    }
    
}
