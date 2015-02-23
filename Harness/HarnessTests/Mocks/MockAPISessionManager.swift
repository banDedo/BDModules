//
//  MockAPISessionManager.swift
//  Harness
//
//  Created by Patrick Hogan on 3/14/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import BDModules
import Foundation

class MockAPISessionManager: APISessionManager {
    
    private(set) var parameters: NSDictionary?
    
    var dataTask: NSURLSessionDataTask? = NSURLSessionDataTask()
    var responseObject: NSDictionary? = NSDictionary()
    var error: NSError?
    
    override init() {
        super.init(dynamicBaseURL: NSURL(string: "https://www.test.com")!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func performRequest(
        #method: APISessionManager.Method,
        path: String,
        parameters: NSDictionary?,
        headers: [ String : String ]?,
        files: [MultipartFile]?,
        handler: URLSessionDataTaskHandler) -> NSURLSessionDataTask! {
            self.parameters = parameters
            handler(dataTask, responseObject, error)
            return dataTask
    }
    
}
