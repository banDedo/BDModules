//
//  UserURLProtocol.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/26/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public class StubURLProtocol: NSURLProtocol {
       
    public lazy var jsonSerializer = JSONSerializer()
    
    public override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return true
    }
    
    public override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }

    public override func startLoading() {
        let headers = jsonSerializer.object(resourceName: "headers_stub", bundle: NSBundle(forClass: self.dynamicType)) as! [ String : AnyObject]
        
        let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: headers)!
        client?.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
        client?.URLProtocol(self, didLoadData: NSData(contentsOfFile: NSBundle(forClass: self.dynamicType).pathForResource(resourceName, ofType: "json")!)!)
        client?.URLProtocolDidFinishLoading(self)        
    }
    
    public override func stopLoading() { }
    
    public var resourceName: String {
        fatalError("resourceName not implemented")
    }
}
