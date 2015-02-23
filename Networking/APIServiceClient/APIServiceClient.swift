//
//  APIServiceClient.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/23/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

public class APIServiceClient<T: ValueObject> {
    
    // MARK:- Properties
    
    public let sessionManager: APISessionManager
        
    // MARK:- Requests
    
    public func performRequest(
        #method: APISessionManager.Method,
        path: String,
        parameters: NSDictionary? = nil,
        files: [ MultipartFile ]? = nil,
        handler: (T?, NSError?) -> Void) {
            
            performRequest(
                method: method,
                path: path,
                parameters: parameters,
                files: files) { [weak self] urlSessionDataTask, responseObject, error in
                    if let strongSelf = self {
                        let completionHandler: URLSessionDataTaskHandler = { [weak self] urlSessionDataTask, responseObject, error in
                            if let strongSelf = self {
                                if error == nil {
                                    let object = strongSelf.objectParser(responseObject!) as! T
                                    handler(object, nil)
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
                                        method: method,
                                        path: path,
                                        parameters: parameters,
                                        files: files,
                                        handler: completionHandler)
                                }
                        }
                        
                        if !willHandleResponse {
                            completionHandler(urlSessionDataTask, responseObject, error)
                        }
                    }
            }
            
    }
        
    private func performRequest(
        #method: APISessionManager.Method,
        path: String,
        parameters: NSDictionary? = nil,
        files: [ MultipartFile ]? = nil,
        handler: URLSessionDataTaskHandler) {
            
            var headers: [ String: String ]?
            if let bearerHeader = accountUserProvider.bearerHeader() {
                headers = [ "Authorization": bearerHeader ]
            }
            
            sessionManager.performRequest(
                method: method,
                path: path,
                parameters: parameters,
                headers: headers,
                files: files,
                handler: handler).resume()
            
    }
    
    // MARK:- Constructors
    
    public init(
        accountUserProvider: AccountUserProvider,
        objectParser: (NSDictionary -> ValueObject),
        sessionManager: APISessionManager,
        oAuth2Authorization: OAuth2Authorization) {
            self.accountUserProvider = accountUserProvider
            self.objectParser = objectParser
            self.sessionManager = sessionManager
            self.oAuth2Authorization = oAuth2Authorization
    }
    
    public init() {
        fatalError("init() not implemented.")
    }
    
    // MARK:- Private
    
    private let accountUserProvider: AccountUserProvider
    private let objectParser: (NSDictionary -> ValueObject)
    internal let oAuth2Authorization: OAuth2Authorization
}
