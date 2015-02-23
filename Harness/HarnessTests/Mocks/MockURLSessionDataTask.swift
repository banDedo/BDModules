//
//  MockURLSessionDataTask.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation

class MockURLSessionDataTask: NSURLSessionDataTask {
    
    class MockResponse: NSHTTPURLResponse {
        
        var code: Int = 401
        
        @objc override var statusCode: Int {
            return code
        }
        
    }
    
    var mockResponse = MockResponse()
    
    @objc override var response: NSURLResponse? {
        return mockResponse
    }
    
}
