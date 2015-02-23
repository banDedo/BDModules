//
//  ModelFactoryMapper.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/23/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Foundation

public class ModelFactoryMapper {

    // MARK:- Enumerated Type
    
    private enum ObjectType: String {
        case User = "User"
        case Location = "Location"
    }

    // MARK:- Enumerated Type

    public class func objectMapperPair(modelFactory: ModelFactory) -> (String, NSDictionary) -> (ValueObject, ValueObjectAPIMapper) {
        return { type, dictionary in
            var object: ValueObject
            var mapper: ValueObjectAPIMapper
            
            switch (ObjectType(rawValue: type)!) {
            case .User:
                object = User(dictionary: dictionary)
                mapper = UserAPIMapper(delegate: modelFactory)
                break
            case .Location:
                object = Location(dictionary: dictionary)
                mapper = LocationAPIMapper(delegate: modelFactory)
            }
            
            return (object, mapper)
        }
    }

}
