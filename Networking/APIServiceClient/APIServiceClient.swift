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
            
            oAuth2Authorization.performAuthenticatedRequest(
                requestHandler: { [weak self] completionHandler in
                    if let strongSelf = self {
                        strongSelf.performRequest(
                            method: method,
                            path: path,
                            parameters: parameters,
                            files: files,
                            handler: completionHandler
                        )
                    }
                }) { [weak self] urlSessionDataTask, responseObject, error in
                    if let strongSelf = self {
                        if error == nil {
                            let object = strongSelf.objectParser(responseObject!) as! T
                            handler(object, nil)
                        } else {
                            handler(nil, error)
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
            if let bearerHeader = authHeaderHandler() {
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
        authHeaderHandler: Void -> String?,
        objectParser: (NSDictionary -> ValueObject),
        sessionManager: APISessionManager,
        oAuth2Authorization: OAuth2Authorization) {
            self.authHeaderHandler = authHeaderHandler
            self.objectParser = objectParser
            self.sessionManager = sessionManager
            self.oAuth2Authorization = oAuth2Authorization
    }
    
    public init() {
        fatalError("init() not implemented.")
    }
    
    // MARK:- Private
    
    private let authHeaderHandler: Void -> String?
    private let objectParser: (NSDictionary -> ValueObject)
    internal let oAuth2Authorization: OAuth2Authorization
}
