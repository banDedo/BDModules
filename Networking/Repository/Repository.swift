//
//  Repository.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/23/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

// MARK:- Enumerated Types

public enum PagingMode: String {
    case Standard = "Standard"
    case Realtime = "Realtime"
}

public enum OrderingType: String {
    case None = "None"
    case Ascending = "Ascending"
    case Descending = "Descending"
}

public enum FetchState: String {
    case NotFetched = "NotFetched"
    case Fetching = "Fetching"
    case Fetched = "Fetched"
    case Error = "Error"
}

public class Repository<T: ModelObject>: Hashable {

    // MARK:- Properties
    
    public let pagingMode: PagingMode
    public let orderingType: OrderingType
    private(set) public var fetchState = FetchState.NotFetched
    private(set) public var atEnd = false
    
    public let path: String
    public let limit = Int(20)
    private(set) public var total = Int(0)
    public let options: NSDictionary
    
    // Realtime Paging: (https://dev.twitter.com/rest/public/timelines)
    private var maxId: String?
    private var sinceId: String?
    
    public var elements = [ T ]()
    
    public var elementCount: Int {
        return elements.count
    }
    
    public var first: T? {
        get {
            return self[0] as T?
        }
    }
    
    public var last: T? {
        get {
            return self[elements.count - 1] as T?
        }
    }

    // MARK:- Constructor
    
    public init(
        path: String,
        options: [ String: AnyObject ] = [ String: AnyObject ](),
        orderingType: OrderingType = .None,
        pagingMode: PagingMode = .Standard,
        accountUserProvider: AccountUserProvider,
        collectionParser: (NSDictionary -> [ ModelObject ]),
        sessionManager: APISessionManager,
        oAuth2Authorization: OAuth2Authorization) {
            self.path = path
            self.options = options
            self.accountUserProvider = accountUserProvider
            self.collectionParser = collectionParser
            self.oAuth2Authorization = oAuth2Authorization
            self.sessionManager = sessionManager
            self.orderingType = orderingType
            self.pagingMode = pagingMode
    }
    
    public init() {
        fatalError("init() not implemented.")
    }

    // MARK:- Fetch

    public func fetchNextPage(
        parameters: NSDictionary? = nil,
        handler: ([ T ]?, NSError?) -> Void) -> Bool {
            
            switch fetchState {
            case .NotFetched:
                break
            case .Fetching:
                return false
            case .Fetched:
                break
            case .Error:
                break
            }

            fetchState = .Fetching
            
            performCollectionRequest(
                parameters: parameters,
                handler: { [weak self] newElements, error in
                    if let strongSelf = self {
                        if error != nil {
                            strongSelf.fetchState = .Error
                        } else {
                            strongSelf.append(newElements!)
                            strongSelf.fetchState = .Fetched
                        }
                        handler(newElements, error)
                    }
            })
            
            return true
    }
    
    private func performCollectionRequest(
        parameters: NSDictionary? = nil,
        handler: ([ T ]?, NSError?) -> Void) {
                        
            let updatedParameters = requestParameters(parameters)
            
            var headers: [ String: String ]?
            if let bearerHeader = accountUserProvider.bearerHeader() {
                headers = [ "Authorization": bearerHeader ]
            }
            
            performRequest(
                parameters: updatedParameters,
                handler: { [weak self] urlSessionDataTask, responseObject, error in
                    if let strongSelf = self {
                        let completionHandler: URLSessionDataTaskHandler = { [weak self] urlSessionDataTask, responseObject, error in
                            if let strongSelf = self {
                                if error == nil {
                                    let newElements = strongSelf.collectionParser(responseObject!) as! [ T ]
                                    strongSelf.updatePagingParameters(newElements, responseObject: responseObject!)
                                    strongSelf.atEnd = strongSelf.total == strongSelf.elements.count
                                    handler(newElements, nil)
                                } else {
                                    handler(nil, error)
                                }
                            }
                        }
                        
                        let willHandleResponse = strongSelf.oAuth2Authorization.willHandleResponse(
                            urlSessionDataTask: urlSessionDataTask,
                            error: error) { [weak self] urlSessionDataTask, responseObject, error in
                                if let strongSelf = self {
                                    strongSelf.performRequest(
                                        parameters: parameters,
                                        handler: completionHandler)
                                }
                        }
                        
                        if !willHandleResponse {
                            completionHandler(urlSessionDataTask, responseObject, error)
                        }
                    }
                })
    }
    
    private func performRequest(
        parameters: NSDictionary? = nil,
        handler: URLSessionDataTaskHandler) {
            
            var headers: [ String: String ]?
            if let bearerHeader = accountUserProvider.bearerHeader() {
                headers = [ "Authorization": bearerHeader ]
            }
            
            sessionManager.performRequest(
                method: .GET,
                path: path,
                parameters: parameters,
                headers: headers,
                handler: handler).resume()
            
    }

    private func requestParameters(parameters: NSDictionary?) -> NSDictionary {
        var updatedParameters = options.mutableCopy() as! NSMutableDictionary
        if parameters != nil {
            updatedParameters.addEntriesFromDictionary(parameters as! [NSObject : AnyObject])
        }
        
        switch pagingMode {
        case .Standard:
            updatedParameters["offset"] = elements.count
            break
        case .Realtime:
            switch orderingType {
            case .Ascending:
                if sinceId != nil {
                    updatedParameters["since_id"] = sinceId
                }
                break
            case .Descending:
                if maxId != nil {
                    updatedParameters["max_id"] = maxId
                }
                break
            case .None:
                break
            }
            break
        }
        
        updatedParameters["limit"] = limit
        
        return updatedParameters.copy() as! NSDictionary
    }
    
    private func updatePagingParameters(newElements: [ T ], responseObject: NSDictionary) {
        let collectionInfo = responseObject["info"] as! NSDictionary
        total = collectionInfo["total"] as! Int
        
        switch pagingMode {
        case .Realtime:
            if count(newElements) != 0 {
                switch orderingType {
                case .Ascending:
                    sinceId = newElements.last!.pagingId!
                    if maxId == nil {
                        maxId = newElements.first!.pagingId!
                    }
                    break
                case .Descending:
                    maxId = newElements.last!.pagingId!
                    if sinceId == nil {
                        sinceId = newElements.first!.pagingId!
                    }
                    break
                case .None:
                    break
                }
            }            
            break
        case .Standard:
            break
        }
    }
    
    // MARK:- Subscripting
    
    private subscript(index: Int) -> T? {
        get {
            if index < 0 || index >= elements.count {
                return nil
            } else {
                return elements[index]
            }
        }
    }

    // MARK:- Hashable
    
    public var hashValue: Int {
        return path.hashValue ^ options.hashValue
    }
    
    // MARK:- Private

    private let accountUserProvider: AccountUserProvider
    private let collectionParser: (NSDictionary -> [ ModelObject ])
    private let oAuth2Authorization: OAuth2Authorization
    private let sessionManager: APISessionManager
    
    private func append(elements: [ T ]) {
        let orderedSet = NSMutableOrderedSet(array: self.elements)
        orderedSet.addObjectsFromArray(elements)
        self.elements = orderedSet.array as! [ T ]
    }

}

// MARK:- Equatable

public func ==<T>(lhs: Repository<T>, rhs: Repository<T>) -> Bool {
    return lhs.path == rhs.path && lhs.options == rhs.options
}
