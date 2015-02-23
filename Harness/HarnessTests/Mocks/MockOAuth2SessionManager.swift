//
//  MockOAuth2SessionManager.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation

class MockOAuth2SessionManager: OAuth2SessionManager {
    
    var shouldRefreshSuccessfully = true
    var refreshRetryCounter: Int = 0
    
    override init(dynamicBaseURL: NSURL, path: String, clientID: String, secret: String) {
        super.init(dynamicBaseURL: dynamicBaseURL, path: path, clientID: clientID, secret: secret)
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override convenience init() {
        self.init(
            dynamicBaseURL: NSURL(),
            path: "",
            clientID: "",
            secret: ""
        )
    }

    override func refreshToken(#refreshToken: String, handler: URLSessionDataTaskHandler?) -> NSURLSessionDataTask! {
        let mockTask = MockURLSessionDataTask()
        
        refreshRetryCounter++
        if shouldRefreshSuccessfully {
            handler!(mockTask, [ "access_token": "1234", "refresh_token": "5678"], nil)
        } else {
            handler!(mockTask, nil, NSError())
        }
        
        return NSURLSessionDataTask()
    }
    
}
