//
//  MockOAuth2Authorization.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation

class MockOAuth2Authorization: OAuth2Authorization {
    
    var handleResponse = true
    var didCallMethod = false
    var handler: URLSessionDataTaskHandler?
    
    override init(
        jsonSerializer: JSONSerializer,
        oAuth2SessionManager: OAuth2SessionManager,
        oAuth2CredentialHandler: (Void -> OAuth2Credential?)) {
            super.init(
                jsonSerializer: jsonSerializer,
                oAuth2SessionManager: oAuth2SessionManager,
                oAuth2CredentialHandler: oAuth2CredentialHandler
            )
    }

    override init() {
        fatalError("init() not implemented.")
    }
    
    override func performAuthenticatedRequest(
        #requestHandler: URLSessionDataTaskHandler -> Void,
        completionHandler: URLSessionDataTaskHandler) {
            self.didCallMethod = true
            self.handler = completionHandler
            if handleResponse {
                requestHandler(completionHandler)
            }
    }

}
