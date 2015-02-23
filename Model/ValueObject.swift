//
//  ValueObject.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/22/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

private let kValueObjectTypeKey = "type"

private let kValueObjectDictionaryKey = "dictionary"

public class ValueObject: NSObject, NSCoding, Equatable {

    // MARK:- Injectable

    public lazy var jsonSerializer = JSONSerializer()

    // MARK:- Properties
    
    private(set) public var dictionary: NSDictionary
    private(set) public var type: String = ""

    public init(dictionary: NSDictionary) {
        self.dictionary = dictionary.mutableCopy() as! NSMutableDictionary
        super.init()
    }

    public override init() {
        fatalError("init() not implemented.")
    }

    // MARK:- NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        dictionary = aDecoder.decodeObjectForKey(kValueObjectDictionaryKey) as! NSMutableDictionary
        super.init()
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(dictionary, forKey: kValueObjectDictionaryKey)
    }

    // MARK:- Logging
    
    public override var description: String {
        get {
            return jsonSerializer.string(object: self.dictionary) ?? ""
        }
    }
    
}

// MARK:- Equatable

public func ==(lhs: ValueObject, rhs: ValueObject) -> Bool {
    return lhs.dictionary.isEqualToDictionary(rhs.dictionary as [ NSObject: AnyObject ])
}

// MARK:- APIMapper

public let kValueObjectTypeApiKeyPath = "type"

public protocol APIMapperDelegate: class {
    func fieldMapper(#apiKeyPath: String, modelKey: String) -> APIFieldMapper
    func fieldMapper(#apiKeyPath: String, modelKey: String, required: Bool) -> APIFieldMapper
    func fieldMapper(#apiKeyPath: String, modelKey: String, type: APIFieldMapper.FieldType) -> APIFieldMapper
    func fieldMapper(#apiKeyPath: String, modelKey: String, required: Bool, type: APIFieldMapper.FieldType) -> APIFieldMapper
    func object(dictionary: NSDictionary) -> ValueObject
}

public class ValueObjectAPIMapper: APIMapper {
    
    // MARK:- Constructor

    public override init(apiFieldMappers: [ APIFieldMapper] = [APIFieldMapper ](), delegate: APIMapperDelegate) {
        super.init(apiFieldMappers: apiFieldMappers, delegate: delegate)
        var apiFieldMappers = super.apiFieldMappers
        apiFieldMappers += [
            delegate.fieldMapper(apiKeyPath: kValueObjectTypeApiKeyPath, modelKey: kValueObjectTypeKey)
        ]
        self.apiFieldMappers = apiFieldMappers
    }
    
}

public class APIMapper: NSObject {
    
    // MARK:- Injectable
    
    public var logVerbose: (String -> Void)?
    public weak var delegate: APIMapperDelegate!

    // MARK:- Properties
    
    internal var apiFieldMappers: [ APIFieldMapper ] = [ APIFieldMapper ]()

    // MARK:- Constructor
    
    public init(apiFieldMappers: [ APIFieldMapper], delegate: APIMapperDelegate) {
        super.init()
        self.apiFieldMappers += apiFieldMappers
        self.delegate = delegate
    }
    
    public override init() {
        fatalError("init() not implemented")
    }
    
    // MARK:- Mapper
    
    public func map(apiDictionary: NSDictionary, object: ValueObject) {
        for apiFieldMapper in apiFieldMappers {
            var APIValue: AnyObject? = apiDictionary.valueForKeyPath(apiFieldMapper.apiKeyPath)
            if APIValue != nil && APIValue!.isKindOfClass(NSNull.self) {
                APIValue = nil
            }
            
            if apiFieldMapper.required && APIValue == nil {
                logVerbose?("Found nil value for key: \(apiFieldMapper.apiKeyPath) for object of type: \(object.type).\n\(apiDictionary)\n")
            }
            
            switch apiFieldMapper.type {
            case .Default:
                object.setValue(APIValue, forKey: apiFieldMapper.modelKey)
                break
            case .ValueObject:
                object.setValue((APIValue != nil) ? delegate.object(APIValue as! NSDictionary) : nil, forKey: apiFieldMapper.modelKey)
                break
            case .ValueArray:
                if APIValue == nil {
                    logVerbose?("Found nil value for key: \(apiFieldMapper.apiKeyPath) for object of type: \(object.type).\n\(apiDictionary)\n")
                }
                
                let JSONArray = !apiFieldMapper.required && APIValue == nil ? [ NSDictionary ]() : APIValue as! [ NSDictionary ]
                let valueArray = JSONArray.map { self.delegate.object($0) }
                object.setValue(valueArray, forKey: apiFieldMapper.modelKey)
                break
            }
        }
        object.dictionary = apiDictionary.mutableCopy() as! NSMutableDictionary
    }
    
    public override var description: String {
        var fieldMapperDescriptions = "\n\n"
        for apiFieldMapper in apiFieldMappers {
            fieldMapperDescriptions += apiFieldMapper.description
            if apiFieldMapper != apiFieldMappers.last! {
                fieldMapperDescriptions += "\n\n"
            }
        }
        return "[APIMapper \(pointerString)]: \(fieldMapperDescriptions)"
    }

}

// MARK:- APIFieldMapper

public class APIFieldMapper: NSObject {
    
    public enum FieldType: String {
        case Default = "Default"
        case ValueObject = "ValueObject"
        case ValueArray = "ValueArray"
    }
    
    private let apiKeyPath: String
    private let modelKey: String
    private let required: Bool
    private let type: FieldType
    
    public init(
        apiKeyPath: String,
        modelKey: String,
        required: Bool,
        type: FieldType) {
            self.apiKeyPath = apiKeyPath
            self.modelKey = modelKey
            self.required = required
            self.type = type
    }

    public override init() {
        fatalError("init() not implemented.")
    }

    public override var description: String {
        return "[APIFieldMapper \(pointerString)]\nAPI Key Path: \(apiKeyPath)\nModel Key: \(modelKey)\nRequired: \(required)\nField Type: \(type.rawValue)"
    }

}
