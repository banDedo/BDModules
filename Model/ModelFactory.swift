//
//  ModelFactory.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/22/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation

public class ModelFactory: APIMapperDelegate {

    // MARK:- Injectable
    
    public var logError: (String -> Void)?
    public lazy var jsonSerializer = JSONSerializer()
    public lazy var objectMapperPair: ((String, NSDictionary) -> (ValueObject, ValueObjectAPIMapper)) = {
        return { string, dictionary in
            return (ValueObject(dictionary: NSDictionary()), ValueObjectAPIMapper(delegate: self))
        }
        }()
    
    // MARK:- Constructor
    
    public init() { }
    
    // MARK:- Properties
    
    public var defaultObjectParser: (NSDictionary -> ValueObject) {
        return { dictionary in
            return self.object(dictionary["data"] as! NSDictionary)
        }
    }

    public var defaultCollectionParser: (NSDictionary -> [ ModelObject ]) {
        return { dictionary in
            let collectionJSON = dictionary["data"] as! [ NSDictionary ]
            var newElements = [ ModelObject ]()
            for JSONObject in collectionJSON {
                let object = self.object(JSONObject)
                newElements.append(object as! ModelObject)
            }
            return newElements
        }
    }
    
    // MARK:- API Mapper
    
    public func object(dictionary: NSDictionary) -> ValueObject {
        let unvalidatedTypeString = dictionary.valueForKeyPath(kValueObjectTypeApiKeyPath) as? String
        
        if unvalidatedTypeString == nil {
            logError?("Found nil value for key: \(kValueObjectTypeApiKeyPath).\n\(dictionary)\n")
        }
        
        let typeString = unvalidatedTypeString!
        
        let (object, mapper) = objectMapperPair(typeString, dictionary)

        object.jsonSerializer = jsonSerializer
        mapper.map(dictionary, object: object)

        return object
    }
    
    // MARK:- APIFieldMapper
    
    public func fieldMapper(
        #apiKeyPath: String,
        modelKey: String) -> APIFieldMapper {
            return fieldMapper(apiKeyPath: apiKeyPath, modelKey: modelKey, required: true)
    }
    
    public func fieldMapper(
        #apiKeyPath: String,
        modelKey: String,
        required: Bool) -> APIFieldMapper {
            return fieldMapper(apiKeyPath: apiKeyPath, modelKey: modelKey, required: required, type: .Default)
    }
    
    public func fieldMapper(
        #apiKeyPath: String,
        modelKey: String,
        type: APIFieldMapper.FieldType) -> APIFieldMapper {
            return fieldMapper(apiKeyPath: apiKeyPath, modelKey: modelKey, required: true, type: type)
    }
    
    public func fieldMapper(
        #apiKeyPath: String,
        modelKey: String,
        required: Bool,
        type: APIFieldMapper.FieldType) -> APIFieldMapper {
            return APIFieldMapper(apiKeyPath: apiKeyPath, modelKey: modelKey, required: required, type: type)
    }
    
}
