//
//  MockAccountUserProvider.swift
//  Harness
//
//  Created by Patrick Hogan on 3/15/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation

class MockAccountUserProvider: AccountUserProvider {
   
    var backingOAuth2Credential: OAuth2Credential?
    
    override var oAuth2Credential: OAuth2Credential! {
        return self.backingOAuth2Credential
    }

}
