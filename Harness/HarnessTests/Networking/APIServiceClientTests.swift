//
//  APIServiceClientTests.swift
//  Harness
//
//  Created by Patrick Hogan on 3/12/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation
import XCTest

class APIServiceClientTests: XCTestCase {
    
    private let path = "/path"
    private let parameters: NSDictionary = [ "key": "value" ]
    private let files = [ MultipartFile ]()
    
    private let jsonSerializer = JSONSerializer()
    
    private lazy var mockAccountUserProvider = MockAccountUserProvider()
    private lazy var mockModelFactory = MockModelFactory()
    private lazy var mockSessionManager = MockAPISessionManager()
    private lazy var mockOAuth2Authorization = MockOAuth2Authorization()
    private lazy var mockOAuth2SessionManager = MockOAuth2SessionManager()
    
    lazy var serviceClient = APIServiceClient<ModelObject>()

    // MARK:- Setup
    
    override func setUp() {
        super.setUp()
        
        mockAccountUserProvider = MockAccountUserProvider()
        mockAccountUserProvider.backingOAuth2Credential = OAuth2Credential(accessToken: "access_token", refreshToken: "refresh_token")

        mockModelFactory = MockModelFactory()

        mockSessionManager = MockAPISessionManager()
        
        mockOAuth2SessionManager = MockOAuth2SessionManager()
        mockOAuth2Authorization = MockOAuth2Authorization(
            jsonSerializer: JSONSerializer(),
            oAuth2SessionManager: mockOAuth2SessionManager,
            oAuth2CredentialHandler: { self.mockAccountUserProvider.oAuth2Credential }
        )
        
        serviceClient = APIServiceClient(
            authHeaderHandler: { self.mockAccountUserProvider.bearerHeader() },
            objectParser: mockModelFactory.defaultObjectParser,
            sessionManager: mockSessionManager,
            oAuth2Authorization: mockOAuth2Authorization
        )
    }

    // MARK:- Success

    func testSuccess() {
        let uuid = "123"
        let pagingId = "abc"
        mockSessionManager.responseObject = responseObject(uuid, pagingId: pagingId)
        
        serviceClient.performRequest(
            method: .GET,
            path: path,
            parameters: parameters) { modelObject, error in
                XCTAssertEqual(modelObject!, self.mockModelFactory.modelObject(uuid, pagingId))
                XCTAssertEqual(self.parameters, self.mockSessionManager.parameters!)
                XCTAssertNil(error)
        }
    }

    // MARK:- Error
    
    func testError() {
        mockSessionManager.error = NSError()
        
        serviceClient.performRequest(
            method: .GET,
            path: path,
            parameters: parameters) { modelObject, error in
                XCTAssertNil(modelObject)
                XCTAssertEqual(self.parameters, self.mockSessionManager.parameters!)
                XCTAssertEqual(error!, self.mockSessionManager.error!)
                XCTAssertEqual(self.mockOAuth2Authorization.didCallMethod, true)
        }
    }
    
    func testCheckOAuth2Authorization() {
        testCheckOAuth2Authorization(false)
    }

    func testCheckOAuth2AuthorizationWithErrorOnSecondRequest() {
        testCheckOAuth2Authorization(true)
    }
    
    func testCheckOAuth2Authorization(errorOnSecondRequest: Bool) {
        mockOAuth2Authorization.handleResponse = false
        mockSessionManager.error = NSError()

        let uuid = "123"
        let pagingId = "abc"
        
        var didCallback = false
        serviceClient.performRequest(
            method: .GET,
            path: path,
            parameters: parameters) { modelObject, error in
                didCallback = true
                if errorOnSecondRequest {
                    XCTAssertEqual(self.mockSessionManager.error!, error!)
                    XCTAssertNil(modelObject)
                } else {
                    XCTAssertEqual(self.mockModelFactory.modelObject(uuid, pagingId), modelObject!)
                    XCTAssertNil(error)
                }
        }

        XCTAssertFalse(didCallback)
        
        if !errorOnSecondRequest {
            mockOAuth2Authorization.handleResponse = true
            mockSessionManager.responseObject = responseObject(uuid, pagingId: pagingId)
            mockSessionManager.error = nil
        }

        self.mockOAuth2Authorization.handler!(MockURLSessionDataTask(), mockSessionManager.responseObject, mockSessionManager.error)

        XCTAssertTrue(didCallback)
    }
    
    // MARK:- Model Convenience
    
    private func responseObject(uuid: String, pagingId: String) -> NSDictionary {
        return [
            "data": self.mockModelFactory.modelResponseObject(uuid, pagingId),
            "code": "OK"
        ]
    }

}
