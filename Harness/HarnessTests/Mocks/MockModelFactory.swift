//
//  MockModelFactory.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation

private let kMockModelFactoryModelObjectTypeKey = "ModelObject"

class MockModelFactory: ModelFactory {

    override init() {
        super.init()
        objectMapperPair = { type, dictionary in
            var object = ModelObject(dictionary: dictionary)
            var mapper = ModelObjectAPIMapper(delegate: self)
            return (object, mapper)
        }
    }
    
    func modelResponseObject(uuid: String, _ pagingId: String) -> NSDictionary {
        return [
            kModelObjectIdApiKeyPath: uuid,
            kModelObjectPagingIdApiKeyPath: pagingId,
            kValueObjectTypeApiKeyPath: kMockModelFactoryModelObjectTypeKey
        ]
    }
    
    func modelObject(uuid: String, _ pagingId: String)-> ModelObject {
        return self.defaultObjectParser([ "data": self.modelResponseObject(uuid, pagingId) ]) as! ModelObject
    }

}
