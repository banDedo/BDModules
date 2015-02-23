//
//  ModelObject.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/22/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

private let kModelObjectIdKey = "uuid"
private let kModelObjectPagingIdKey = "pagingId"

public class ModelObject: ValueObject, Hashable {
   
    // MARK:- Properties
        
    private(set) public var uuid: String = ""
    private(set) public var pagingId: String?
    
    // MARK:- Hashable

    public override var hashValue: Int {
        return uuid.hash
    }

    public override var hash: Int {
        return hashValue
    }

    public override func isEqual(object: AnyObject?) -> Bool {
        if object != nil && object!.isKindOfClass(self.dynamicType) {
            let model = object as! ModelObject
            return self.type == model.type && self.uuid == model.uuid
        } else {
            return false
        }
    }

}

// MARK:- Equatable

public func ==(lhs: ModelObject, rhs: ModelObject) -> Bool {
    return lhs.isEqual(rhs)
}

// MARK:- Model Object API Mapper

public let kModelObjectIdApiKeyPath = "id"
public let kModelObjectPagingIdApiKeyPath = "paging_id"

public class ModelObjectAPIMapper: ValueObjectAPIMapper {

    // MARK:- Constructor

    public override init(apiFieldMappers: [ APIFieldMapper] = [APIFieldMapper ](), delegate: APIMapperDelegate) {
        super.init(apiFieldMappers: apiFieldMappers, delegate: delegate)
        var apiFieldMappers = super.apiFieldMappers
        apiFieldMappers += [
            delegate.fieldMapper(apiKeyPath: kModelObjectIdApiKeyPath, modelKey: kModelObjectIdKey),
            delegate.fieldMapper(apiKeyPath: kModelObjectPagingIdApiKeyPath, modelKey: kModelObjectPagingIdKey, required: false)
        ]
        self.apiFieldMappers = apiFieldMappers
    }

}
