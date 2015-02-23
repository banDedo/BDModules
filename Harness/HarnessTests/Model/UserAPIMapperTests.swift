//
//  UserAPIMapperTests.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation
import XCTest

class UserAPIMapperTests: XCTestCase {

    // MARK:- Properties
    
    var jsonSerializer = JSONSerializer()
    var mockModelFactory = MockModelFactory()
    lazy var userAPIMapper: UserAPIMapper = { return UserAPIMapper(delegate: self.mockModelFactory) }()

    // MARK:- Setup
    
    override func setUp() {
        super.setUp()
        
        jsonSerializer = JSONSerializer()
        mockModelFactory = MockModelFactory()
        userAPIMapper = UserAPIMapper(delegate: self.mockModelFactory)
    }
    
    // MARK:- Tests
    
    func testParseUser() {
        let dictionary = jsonSerializer.object(
            resourceName: "me_stub",
            bundle: NSBundle(forClass: User.self)) as! NSDictionary
        
        let userDictionary = dictionary["data"] as! NSDictionary
        
        let user = User(dictionary: userDictionary)
        userAPIMapper.map(userDictionary, object: user)
        
        XCTAssertEqual(user.uuid, userDictionary[kModelObjectIdApiKeyPath] as! String)
        XCTAssertEqual(user.type, userDictionary[kValueObjectTypeApiKeyPath] as! String)
        XCTAssertEqual(user.firstName, userDictionary[kUserFirstNameApiKeyPath] as! String)
        XCTAssertEqual(user.lastName, userDictionary[kUserLastNameApiKeyPath] as! String)
        XCTAssertEqual(user.email, userDictionary[kUserEmailApiKeyPath] as! String)
        XCTAssertEqual(user.phoneNumber!, userDictionary[kUserPhoneNumberApiKeyPath] as! String)
        XCTAssertEqual(user.coverImageURL!, userDictionary[kUserCoverImageURLApiKeyPath] as! String)
        XCTAssertEqual(user.profileImageURL!, userDictionary[kUserProfileImageURLApiKeyPath] as! String)
    }

}
