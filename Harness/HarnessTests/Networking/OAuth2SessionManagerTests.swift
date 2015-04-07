//
//  OAuth2AuthorizationTests.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/11/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation
import XCTest

class OAuth2AuthorizationTests: XCTestCase {
        
    var mockTask = MockURLSessionDataTask()
    
    lazy var mockAccountUserProvider = MockAccountUserProvider()
    lazy var mockSessionManager = MockOAuth2SessionManager()
    lazy var oAuth2Authorization = OAuth2Authorization()

    override func setUp() {
        
        super.setUp()
        
        mockTask = MockURLSessionDataTask()
        
        mockAccountUserProvider = MockAccountUserProvider()
        mockAccountUserProvider.backingOAuth2Credential = OAuth2Credential(
            accessToken: "access_token",
            refreshToken: "refresh_token"
        )
        
        mockSessionManager = MockOAuth2SessionManager()
        
        oAuth2Authorization = OAuth2Authorization(
            jsonSerializer: JSONSerializer(),
            oAuth2SessionManager: mockSessionManager,
            oAuth2CredentialHandler: { self.mockAccountUserProvider.oAuth2Credential }
        )
        
    }

    func testShouldNotHandleResponseInAbsenceOfError() {
        
        var didCallback = false
        
        oAuth2Authorization.performAuthenticatedRequest(
            requestHandler: { handler in }) { urlSessionDataTask, responseObject, error in
                didCallback = true
        }
        XCTAssertFalse(didCallback)
        
    }
    
    func testShouldNotHandleResponseIfStatusCodeIsNot401() {
        
        var didCallback = false
        
        mockTask.mockResponse.code = 403

        oAuth2Authorization.performAuthenticatedRequest(
            requestHandler: { handler in }) { urlSessionDataTask, responseObject, error in
                didCallback = true
        }
        
        XCTAssertFalse(didCallback)
        
    }

    func testShouldCallHandlerOnSuccessfulRefresh() {
        
        var requestCounter = 0
        var didCallback = false
        
        oAuth2Authorization.performAuthenticatedRequest(
            requestHandler: { handler in
                handler(self.mockTask, nil, requestCounter++ == 0 ? NSError() : nil)
            }) { urlSessionDataTask, responseObject, error in
                if error == nil {
                    didCallback = true
                }
        }
        
        XCTAssertTrue(didCallback)
        
    }

    func testAuthorizationHandlerShouldNotRetryRequestOnFailedRefresh() {
        
        mockSessionManager.shouldRefreshSuccessfully = false
        
        var didReturnError = false

        oAuth2Authorization.performAuthenticatedRequest(
            requestHandler: { handler in
                handler(self.mockTask, nil, NSError())
            }) { urlSessionDataTask, responseObject, error in
                if error != nil {
                    didReturnError = true
                }
        }

        XCTAssertTrue(didReturnError)
        XCTAssertEqual(mockSessionManager.refreshRetryCounter, 1)

    }

}
