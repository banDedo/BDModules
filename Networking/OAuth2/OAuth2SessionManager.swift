//
//  OAuth2SessionManager.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/20/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

public let kResourceClientIdApiKeyPath = "client_id"
public let kResourceSecretApiKeyPath = "client_secret"

private let kOAuth2SessionManagerClientIDKey = "clientID"
private let kOAuth2SessionManagerSecretKey = "secret"
private let kOAuth2SessionManagerPathKey = "path"
private let kOAuth2SessionManagerCredentialKey = "credential"

@objc public protocol OAuth2SessionManagerDelegate {
    func oAuth2SessionManager(oAuth2SessionManager: OAuth2SessionManager, didUpdateCredential credential: OAuth2Credential)
}

public class OAuth2SessionManager: APISessionManager {
    
    // MARK:- Injectable

    public weak var delegate: OAuth2SessionManagerDelegate?

    // MARK:- Constructor

    public init(
        dynamicBaseURL: NSURL,
        path: String,
        clientID: String,
        secret: String) {
            self.path = path
            self.clientID = clientID
            self.secret = secret
            super.init(dynamicBaseURL: dynamicBaseURL, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init() {
        fatalError("init() has not been implemented")
    }

    // MARK:- Authorization

    public func tokenGrant(
        #username: String,
        password: String,
        handler: URLSessionDataTaskHandler?) -> NSURLSessionDataTask! {
            var parameters: [ String: AnyObject ] = baseAuthorizationParameters()
            parameters["grant_type"] = "password"
            parameters["username"] = username
            parameters["password"] = password
            return performRequest(method: .POST, path: path, parameters: parameters) { URLSessionDataTask, responseObject, error in
                if error == nil && responseObject != nil {
                    let oAuth2Credential = OAuth2Credential(accessToken: (responseObject!["access_token"] as? String)!, refreshToken: (responseObject!["refresh_token"] as? String)!)
                    self.delegate?.oAuth2SessionManager(self, didUpdateCredential: oAuth2Credential)
                }
                
                if handler != nil {
                    handler!(URLSessionDataTask, responseObject, error)
                }
            }
    }
    
    public func refreshToken(
        #refreshToken: String,
        handler: URLSessionDataTaskHandler?) -> NSURLSessionDataTask! {
            var parameters: [ String: AnyObject ] = baseAuthorizationParameters()
            parameters["grant_type"] = "refresh_token"
            parameters["refresh_token"] = refreshToken;
            return performRequest(method: .POST, path: path, parameters: parameters) { URLSessionDataTask, responseObject, error in
                if error == nil && responseObject != nil {
                    let oAuth2Credential = OAuth2Credential(accessToken: (responseObject!["access_token"] as? String)!, refreshToken: (responseObject!["refresh_token"] as? String)!)
                    self.delegate?.oAuth2SessionManager(self, didUpdateCredential: oAuth2Credential)
                }
                
                if handler != nil {
                    handler!(URLSessionDataTask, responseObject, error)
                }
            }
    }

    // MARK:- Private
    
    private var isRefreshing = false
    
    private let clientID: String
    private let secret: String
    
    private let path: String
    
    private func baseAuthorizationParameters() -> [ String: AnyObject ] {
        return [ kResourceClientIdApiKeyPath : self.clientID, kResourceSecretApiKeyPath : self.secret ];
    }
    
}

public class OAuth2Authorization {
    
    // MARK:- Constructor
    
    public init(
        jsonSerializer: JSONSerializer,
        oAuth2SessionManager: OAuth2SessionManager,
        oAuth2CredentialHandler: (Void -> OAuth2Credential?)) {
            self.jsonSerializer = jsonSerializer
            self.oAuth2SessionManager = oAuth2SessionManager
            self.oAuth2CredentialHandler = oAuth2CredentialHandler
    }
    
    public init() {
        fatalError("init() not implemented")
    }
    
    // MARK:- Enqueued Handlers
    
    public func willHandleResponse(
        #urlSessionDataTask: NSURLSessionDataTask,
        error: NSError?,
        handler: URLSessionDataTaskHandler) -> Bool {
            let accessToken = oAuth2CredentialHandler()?.accessToken
            
            if error == nil || oAuth2CredentialHandler() == nil {
                return false
            } else {
                let statusCode = (urlSessionDataTask.response as? NSHTTPURLResponse)?.statusCode
                let isUnauthorizedLoggedInRequest = (statusCode != nil && statusCode! == 401 && oAuth2CredentialHandler() != nil)
                
                if isUnauthorizedLoggedInRequest {
                    if oAuth2CredentialHandler()?.accessToken != accessToken {
                        // Access token changed while this request was inflight.  Retry one more time.
                        handler(urlSessionDataTask, nil, error)
                    } else {
                        // Access token is the same as when requested.  Lock up and enqueue request
                        objc_sync_enter(self)
                        
                        enqueuedHandlers.append(handler)
                        
                        let queueHandler: URLSessionDataTaskHandler = { urlSessionDataTask, responseObject, error in
                            objc_sync_enter(self)
                            
                            let enqueuedHandlers = self.enqueuedHandlers
                            self.enqueuedHandlers.removeAll(keepCapacity: false)
                            
                            for enqueuedHandler in enqueuedHandlers {
                                enqueuedHandler(urlSessionDataTask, responseObject, error)
                            }
                            
                            objc_sync_exit(self)
                        }
                        
                        // Only refresh once at any given time.  Queue will be serviced at the end of one successful authorization.
                        if !oAuth2SessionManager.isRefreshing {
                            oAuth2SessionManager.isRefreshing = true
                            oAuth2SessionManager.refreshToken(refreshToken: oAuth2CredentialHandler()!.refreshToken, handler: { [weak self] urlSessionDataTask, responseObject, error in
                                if let strongSelf = self {
                                    strongSelf.oAuth2SessionManager.isRefreshing = false
                                    queueHandler(urlSessionDataTask, responseObject, error)
                                }
                            })
                        }
                        objc_sync_exit(self)
                    }
                    
                    return true
                }
                
                return false
            }
            
    }
    
    // MARK:- Private Properties
    
    private let oAuth2CredentialHandler: (Void -> OAuth2Credential?)
    private let jsonSerializer: JSONSerializer
    private let oAuth2SessionManager: OAuth2SessionManager

    private var enqueuedHandlers = [ URLSessionDataTaskHandler ]()

}
