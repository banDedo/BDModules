//
//  RepositoryTests.swift
//  Harness
//
//  Created by Patrick Hogan on 3/12/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation
import XCTest

class RepositoryTests: XCTestCase {
            
    private let path = "/path"
    private let options = [ "key": "value" ]
    private let orderingType = OrderingType.None
    private let pagingMode = PagingMode.Standard
    
    private lazy var mockAccountUserProvider = MockAccountUserProvider()
    private lazy var mockModelFactory = MockModelFactory()
    private lazy var mockSessionManager = MockAPISessionManager()
    private lazy var mockOAuth2Authorization = MockOAuth2Authorization()
    private lazy var mockOAuth2SessionManager = MockOAuth2SessionManager()

    lazy var repository = Repository<ModelObject>()
    
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
        

        repository = Repository<ModelObject>(
            path: path,
            options: options,
            orderingType: orderingType,
            pagingMode: pagingMode,
            authHeaderHandler: { self.mockAccountUserProvider.bearerHeader() },
            collectionParser: mockModelFactory.defaultCollectionParser,
            sessionManager: mockSessionManager,
            oAuth2Authorization: mockOAuth2Authorization
        )
    }
    
    // MARK:- Success
    
    func testFetchingAfterFetchStandardAscending() {
        testMultipleFetches(.Standard, .Ascending)
    }

    func testFetchingAfterFetchRealtimeAscending() {
        testMultipleFetches(.Realtime, .Ascending)
    }

    func testFetchingAfterFetchStandardDescending() {
        testMultipleFetches(.Standard, .Descending)
    }
    
    func testFetchingAfterFetchRealtimeDescending() {
        testMultipleFetches(.Realtime, .Descending)
    }

    // MARK:- Error

    func testFetchingAfterError() {
        mockSessionManager.error = NSError()
        
        var isSecondHandlerCalled = false
        repository.fetch { newElements, error in
            XCTAssertEqual(self.repository.fetchState, .Error)
            XCTAssertEqual(self.repository.elementCount, 0)
            XCTAssertEqual(error!, self.mockSessionManager.error!)
            
            let uuid = "123"
            let pagingId = "abc"
            self.mockSessionManager.responseObject = self.responseObject([ (uuid, pagingId) ], count: 1, total: 2)
            self.mockSessionManager.error = nil
            
            self.repository.fetch() { newElements, error in
                isSecondHandlerCalled = true
                XCTAssertEqual(self.repository.fetchState, .Fetched)
                XCTAssertEqual(self.repository.elementCount, 1)
                XCTAssertEqual(self.repository.last!, self.mockModelFactory.modelObject(uuid, pagingId))
                XCTAssertNil(error)
            }
        }
        
        XCTAssertTrue(isSecondHandlerCalled)
    }
    
    func testDoesNotFetchAtEnd(error: Bool) {
        mockSessionManager.responseObject = responseObject([ ("123", "abc") ], count: 1, total: 1)
        
        var isSecondHandlerCalled = false
        repository.fetch { newElements, error in
            XCTAssertEqual(self.repository.fetchState, .Fetched)
            XCTAssertEqual(self.repository.elementCount, 1)
            XCTAssertTrue(self.repository.atEnd)
            XCTAssertNil(error)

            self.repository.fetch() { newElements, error in
                isSecondHandlerCalled = true
            }
        }
        
        XCTAssertFalse(isSecondHandlerCalled)
    }
    
    func testMultipleFetches(pagingMode: PagingMode, _ orderingType: OrderingType) {
        repository = Repository<ModelObject>(
            path: path,
            options: options,
            orderingType: orderingType,
            pagingMode: pagingMode,
            authHeaderHandler: { self.mockAccountUserProvider.bearerHeader() },
            collectionParser: mockModelFactory.defaultCollectionParser,
            sessionManager: mockSessionManager,
            oAuth2Authorization: mockOAuth2Authorization
        )

        let firstUuid = "123"
        let firstPagingId = "abc"
        let secondUuid = "456"
        let secondPagingId = "def"
        
        mockSessionManager.responseObject = responseObject([ (firstUuid, firstPagingId), (secondUuid, secondPagingId) ], count: 2, total: 3)
        
        var isSecondHandlerCalled = false
        repository.fetch { newElements, error in
            
            let thirdUuid = "789"
            let thirdPagingId = "ghi"
            // Purposely add second uuid again.  Underlying set implementation should not append again
            self.mockSessionManager.responseObject = self.responseObject([ (secondUuid, secondPagingId), (thirdUuid, thirdPagingId) ], count: 3, total: 3)
            
            self.repository.fetch() { newElements, error in
                
                XCTAssertEqual(self.repository.fetchState, .Fetched)
                XCTAssertEqual(self.repository.elementCount, 3)
                XCTAssertNil(error)

                switch pagingMode {
                case .Standard:
                    XCTAssertEqual(self.mockSessionManager.parameters!["offset"] as! Int, 2)
                    XCTAssertNil(self.mockSessionManager.parameters!["since_id"] as? String)
                    XCTAssertNil(self.mockSessionManager.parameters!["max_id"] as? String)
                    break
                case .Realtime:
                    switch orderingType {
                    case .Ascending:
                        XCTAssertEqual(self.mockSessionManager.parameters!["since_id"] as! String, secondPagingId)
                        XCTAssertNil(self.mockSessionManager.parameters!["max_id"] as? String)
                        break
                    case .Descending:
                        XCTAssertNil(self.mockSessionManager.parameters!["since_id"] as? String)
                        XCTAssertEqual(self.mockSessionManager.parameters!["max_id"] as! String, secondPagingId)
                        break
                    case .None:
                        break
                    }
                    XCTAssertNil(self.mockSessionManager.parameters!["offset"] as? Int)
                    break
                }

                isSecondHandlerCalled = true
                
                XCTAssertEqual(self.repository.fetchState, .Fetched)
                XCTAssertEqual(self.repository.elementCount, 3)
                XCTAssertEqual(self.repository.first!, self.mockModelFactory.modelObject(firstUuid, firstPagingId))
                XCTAssertEqual(self.repository.elements[1], self.mockModelFactory.modelObject(secondUuid, secondPagingId))
                XCTAssertEqual(self.repository.last!, self.mockModelFactory.modelObject(thirdUuid, thirdPagingId))
                
            }
            
        }
        
        XCTAssertTrue(isSecondHandlerCalled)
    }
    
    // MARK:- Model Convenience
        
    private func responseObject(ids: [ (String, String) ], count: Int, total: Int) -> NSDictionary {
        var array = [ NSDictionary ]()

        for (uuid, pagingId) in ids {
            array.append(self.mockModelFactory.modelResponseObject(uuid, pagingId))
        }
        
        return [
            "data": array,
            "info": [ "count": count, "total": total ],
            "code": "OK"
        ]
    }

}
