//
//  APIFactory.swift
//  BDModules
//
//  Created by Patrick Hogan on 3/3/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import FXKeychain
import Foundation

public class APIFactory {
    
    // MARK:- Injectable
    
    public lazy var jsonSerializer: JSONSerializer = JSONSerializer()
    public lazy var modelFactory = ModelFactory()
    
    public func configureOAuth2Properties() {
    }
    
    // MARK:- Account User
    
    public lazy var accountUserProvider: AccountUserProvider = {
        let accountUserProvider = AccountUserProvider()
        accountUserProvider.keychain = self.keychain
        accountUserProvider.modelFactory = self.modelFactory
        return accountUserProvider
        }()
    
    // MARK:- User
    
    public func userAPI() -> UserAPI {
        let userAPI = UserAPI()
        userAPI.accountUserProvider = accountUserProvider
        userAPI.oAuth2SessionManager = oAuth2SessionManager()
        userAPI.userServiceClient = userServiceClient()
        return userAPI
    }
    
    private func userServiceClient() -> APIServiceClient<User> {
        let sessionManager = self.sessionManager()
        sessionManager.session.configuration.protocolClasses = [ UserURLProtocol.self ]
        
        return APIServiceClient<User>(
            accountUserProvider: accountUserProvider,
            objectParser: modelFactory.defaultObjectParser,
            sessionManager: sessionManager,
            oAuth2Authorization: oAuth2Authorization
        )
    }

    // MARK: - Location
    
    public func mapLocationRepository(userUuid: String) -> Repository<Location> {
        let sessionManager = self.sessionManager()
        sessionManager.session.configuration.protocolClasses = [ LocationURLProtocol.self ]

        return Repository<Location>(
            path: APIResource.userLocationsPath(userUuid: userUuid),
            accountUserProvider: accountUserProvider,
            collectionParser: modelFactory.defaultCollectionParser,
            sessionManager: sessionManager,
            oAuth2Authorization: oAuth2Authorization
        )
    }

    public func favoriteLocationRepository(userUuid: String) -> Repository<Location> {
        let sessionManager = self.sessionManager()
        
        FavoriteLocationURLProtocol.counter = 0
        sessionManager.session.configuration.protocolClasses = [ FavoriteLocationURLProtocol.self ]
        
        return Repository<Location>(
            path: APIResource.userLocationsPath(userUuid: userUuid),
            accountUserProvider: accountUserProvider,
            collectionParser: modelFactory.defaultCollectionParser,
            sessionManager: sessionManager,
            oAuth2Authorization: oAuth2Authorization
        )
    }

    // MARK:- Persistence
    
    public var keychain: FXKeychain {
        return FXKeychain(
            service: NSBundle(forClass: self.dynamicType).bundleIdentifier!,
            accessGroup: nil,
            accessibility: FXKeychainAccess.AccessibleWhenUnlocked
        )
    }
    
    // MARK:- Session Manager
    
    public func sessionManager() -> APISessionManager {
        let sessionManager = APISessionManager(dynamicBaseURL: baseURL)
        
        sessionManager.jsonSerializer = jsonSerializer
        sessionManager.logWarning = log(logger, .Warning)
        sessionManager.logInfo = log(logger, .Info)
        
        sessionManager.setTaskWillPerformHTTPRedirectionBlock { URLSession, URLSessionTask, response, request -> NSURLRequest! in
            if let baseURLString: String = (response as? NSHTTPURLResponse)?.allHeaderFields["Location"] as? String where count(baseURLString) > 0 {
                self.baseURL = NSURL(string: baseURLString)!
                sessionManager.dynamicBaseURL = self.baseURL
            }
            
            return request
        }
        
        return sessionManager
    }
    
    public lazy var oAuth2Authorization: OAuth2Authorization = {
        let oAuth2Authorization = OAuth2Authorization(
            accountUserProvider: self.accountUserProvider,
            jsonSerializer: self.jsonSerializer,
            oAuth2SessionManager: self.oAuth2SessionManager()
        )
        return oAuth2Authorization
        }()
    
    public func oAuth2SessionManager() -> OAuth2SessionManager {
        let oAuth2SessionManager = OAuth2SessionManager(
            dynamicBaseURL: baseURL,
            path: "oauth/token",
            clientID: clientID,
            secret: secret
        )
        
        oAuth2SessionManager.jsonSerializer = jsonSerializer
        oAuth2SessionManager.logWarning = log(logger, .Warning)
        oAuth2SessionManager.logInfo = log(logger, .Info)
        
        oAuth2SessionManager.session.configuration.protocolClasses = [ OAuth2SessionManagerURLProtocol.self ]
        
        oAuth2SessionManager.delegate = accountUserProvider
        return oAuth2SessionManager
    }
    
    // MARK:- Logging
    
    public lazy var logger: Logger = {
        let logger = Logger(tag: "API", applicationName: "BDModules")
        logger.enabled = false
        logger.synchronous = true
        logger.thresholdLevel = .Info
        return logger
        }()
    
    // MARK:- Private Configuration
    
    private lazy var baseURL: NSURL = {
        return NSURL(string: self.configuration["host_name"] as! String)!
        }()
    
    private lazy var clientID: String = {
        return self.configuration["client_id"] as! String
        }()
    
    private lazy var secret: String = {
        return self.configuration["secret"] as! String
        }()
    
    private lazy var configuration: NSDictionary = {
        let configuration = NSDictionary(contentsOfFile: NSBundle(forClass: self.dynamicType).pathForResource("APIConfiguration", ofType: "plist")!)
        return configuration!
        }()
    
}
