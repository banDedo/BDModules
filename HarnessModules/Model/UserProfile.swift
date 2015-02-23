//
//  UserProfile.swift
//  BDModules
//
//  Created by Patrick Hogan on 12/7/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

@objc public protocol UserProfile: Profile {
   
    var firstName: String { get }
    var lastName: String { get }
    var email: String { get }
    var phoneNumber: String? { get }
    
}

@objc public protocol Profile {
    
    var uuid: String { get }
    var displayName: String { get }
    var profileImageURL: String? { get }
    var coverImageURL: String? { get }
    
}
