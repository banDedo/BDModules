//
//  AccountUserProvider.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/8/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation
import FXKeychain

private let kAccountUserProviderKey = "kAccountUserProviderKey"

public class AccountUserProvider: NSObject, OAuth2SessionManagerDelegate {
   
    // MARK:- Injectable
    
    public lazy var keychain = FXKeychain()
    public lazy var modelFactory = ModelFactory()

    // MARK:- Properties

    private(set) public lazy var accountUser: AccountUser = {
        var accountUser: AccountUser = AccountUser()
        
        if let savedAccountUser = self.keychain.objectForKey(kAccountUserProviderKey) as? AccountUser {
            if savedAccountUser.oAuth2Credential == nil {
                self.keychain.setObject(nil, forKey: kAccountUserProviderKey)
            } else {
                accountUser.user = self.modelFactory.object(savedAccountUser.user!.dictionary) as? User
                accountUser.oAuth2Credential = savedAccountUser.oAuth2Credential
            }
        }
        
        return accountUser
        }()
    
    public var user: User! {
        return accountUser.user!
    }
    
    public var oAuth2Credential: OAuth2Credential! {
        return accountUser.oAuth2Credential!
    }

    // MARK:- OAuth2

    public func bearerHeader() -> String? {
        if let accessToken = accountUser.oAuth2Credential?.accessToken {
            return "Bearer \(accessToken)"
        } else {
            return nil
        }
    }

    // MARK:- Persistence

    public func userPersistenceHandler() -> (User -> Void) {
        return { user in
            self.accountUser.user = user
            self.keychain.setObject(self.accountUser, forKey: kAccountUserProviderKey)
        }
    }

    public func logout() {
        keychain.setObject(nil, forKey: kAccountUserProviderKey)
        accountUser = AccountUser()
    }

    // MARK:- OAuth2SessionManagerDelegate
    
    public func oAuth2SessionManager(oAuth2SessionManager: OAuth2SessionManager, didUpdateCredential credential: OAuth2Credential) {
        accountUser.oAuth2Credential = credential
        keychain.setObject(accountUser, forKey: kAccountUserProviderKey)
    }

}
