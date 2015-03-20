//
//  APISessionManager.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/19/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import AFNetworking
import Foundation

private let kAPISessionManagerDynamicBaseURLKey = "dynamicBaseURL"

public typealias URLSessionDataTaskHandler = (NSURLSessionDataTask!, NSDictionary?, NSError?) -> Void

public class APISessionManager: AFHTTPSessionManager {
    
    // MARK:- Enumerated Types

    public enum Method: String {
        case HEAD = "HEAD"
        case GET = "GET"
        case PUT = "PUT"
        case POST = "POST"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
    }
    
    // MARK:- Injectable
    
    public lazy var jsonSerializer = JSONSerializer()
    public var logWarning: (String -> Void)?
    public var logInfo: (String -> Void)?

    // MARK:- Properties

    public var dynamicBaseURL: NSURL
    
    // MARK:- Constructor

    public init(dynamicBaseURL: NSURL, sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
        self.dynamicBaseURL = dynamicBaseURL
        super.init(baseURL: nil, sessionConfiguration: sessionConfiguration)
        self.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.allZeros)
        self.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.allZeros)
    }

    public init() {
        fatalError("init() has not been implemented")
    }

    required public init(coder aDecoder: NSCoder) {
        dynamicBaseURL = aDecoder.decodeObjectForKey(kAPISessionManagerDynamicBaseURLKey) as! NSURL
        super.init(coder: aDecoder)
    }
    
    public override func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(dynamicBaseURL, forKey: kAPISessionManagerDynamicBaseURLKey)
        super.encodeWithCoder(coder)
    }

    // MARK:- Requests
    
    public func performRequest(
        #method: Method,
        path: String,
        parameters: NSDictionary?,
        headers: [ String: String ]? = nil,
        files: [ MultipartFile ]? = nil,
        handler: URLSessionDataTaskHandler) -> NSURLSessionDataTask! {
            if headers != nil {
                for (key, value) in headers! {
                    requestSerializer?.setValue(value, forHTTPHeaderField: key)
                }
            } else {
                if let oldHeaders = requestSerializer?.HTTPRequestHeaders {
                    for (key, _) in oldHeaders {
                        requestSerializer?.setValue(nil, forHTTPHeaderField: key as! String)
                    }
                }
            }
            
            let URLString = NSURL(string: path, relativeToURL: self.dynamicBaseURL)?.absoluteString
            let URLSessionDataTask: NSURLSessionDataTask
            if files == nil {
                switch method {
                case .HEAD:
                    URLSessionDataTask = super.HEAD(URLString, parameters: parameters, success: self.success(method, handler: handler), failure: self.failure(method, handler: handler))
                    break
                case .GET:
                    URLSessionDataTask = super.GET(URLString, parameters: parameters, success: self.success(method, handler: handler), failure: self.failure(method, handler: handler))
                    break
                case .PUT:
                    URLSessionDataTask = super.PUT(URLString, parameters: parameters, success: self.success(method, handler: handler), failure: self.failure(method, handler: handler))
                    break
                case .POST:
                    URLSessionDataTask = super.POST(URLString, parameters: parameters, success: self.success(method, handler: handler), failure: self.failure(method, handler: handler))
                    break
                case .PATCH:
                    URLSessionDataTask = super.PATCH(URLString, parameters: parameters, success: self.success(method, handler: handler), failure: self.failure(method, handler: handler))
                    break
                case .DELETE:
                    URLSessionDataTask = super.DELETE(URLString, parameters: parameters, success: self.success(method, handler: handler), failure: self.failure(method, handler: handler))
                    break
                }
                URLSessionDataTask.suspend()
            } else {
                let request = requestSerializer.multipartFormRequestWithMethod(
                    method.rawValue,
                    URLString: URLString,
                    parameters: parameters as? [ NSObject : AnyObject ],
                    constructingBodyWithBlock: { formData in
                        for file in files! {
                            formData.appendPartWithFileData(file.data, name: file.name, fileName: file.fileName, mimeType: file.mimeType)
                        }
                        return
                    },
                    error: nil)
                
                let taskKey = "task"
                var taskContainer = NSMutableDictionary()
                URLSessionDataTask = uploadTaskWithStreamedRequest(
                    request,
                    progress:nil) { response, responseObject, error in
                        if error == nil {
                            self.success(method, handler: handler)(taskContainer[taskKey] as? NSURLSessionDataTask, responseObject as? NSDictionary)
                        } else {
                            self.failure(method, handler: handler)(taskContainer[taskKey] as? NSURLSessionDataTask, error)
                        }
                }
                taskContainer[taskKey] = URLSessionDataTask
            }
            
            logRequest(method, request: URLSessionDataTask.originalRequest, parameters: parameters)
            return URLSessionDataTask
    }
    
    /// MARK:- HEAD success handler
    private func success(method: Method, handler: URLSessionDataTaskHandler?) -> ((NSURLSessionDataTask!) -> Void) {
        return { URLSessionDataTask in
            if URLSessionDataTask.state == NSURLSessionTaskState.Canceling {
                self.logCancel(method, URLSessionDataTask: URLSessionDataTask, responseObject: nil)
            } else {
                self.logSuccess(method, request: URLSessionDataTask.originalRequest, response: (URLSessionDataTask.response as? NSHTTPURLResponse)!, responseObject: nil)
                if handler != nil {
                    handler!(URLSessionDataTask, nil, nil)
                }
            }
        }
    }
    
    /// MARK:- Success handler
    private func success(method: Method, handler: URLSessionDataTaskHandler?) -> ((NSURLSessionDataTask!, AnyObject!) -> Void) {
        return { URLSessionDataTask, responseObject in
            if URLSessionDataTask.state == NSURLSessionTaskState.Canceling {
                self.logCancel(method, URLSessionDataTask: URLSessionDataTask, responseObject: responseObject as? NSDictionary)
            } else {
                self.logSuccess(method, request: URLSessionDataTask.originalRequest, response: (URLSessionDataTask.response as? NSHTTPURLResponse)!, responseObject: responseObject as? NSDictionary)
                if handler != nil {
                    handler!(URLSessionDataTask, responseObject as? NSDictionary, nil)
                }
            }
        }
    }
    
    /// MARK:- Failure handler
    private func failure(method: Method, handler: URLSessionDataTaskHandler?) -> ((NSURLSessionDataTask!, NSError!) -> Void) {
        return { URLSessionDataTask, error in
            if URLSessionDataTask.state == NSURLSessionTaskState.Canceling {
                self.logCancel(method, URLSessionDataTask: URLSessionDataTask, responseObject: nil)
            } else {
                self.logFailure(method, request: URLSessionDataTask.originalRequest, response: URLSessionDataTask.response as? NSHTTPURLResponse, error: error)
                if handler != nil {
                    handler!(URLSessionDataTask, nil, error)
                }
            }
        }
    }
 
    private func logRequest(method: Method, request: NSURLRequest, parameters: NSDictionary?) {
        let headers: NSDictionary? = request.allHTTPHeaderFields != nil ? request.allHTTPHeaderFields! as NSDictionary : nil
        let headersSerialization = headers != nil ? jsonSerializer.string(object: headers) : nil
        let headersLogFormat = headersSerialization != nil && count(headersSerialization!) != 0 ? "\nHeaders: \(headersSerialization!)" : ""
        
        let parametersJSONSerialization = jsonSerializer.string(object: parameters)
        let showParameters = !requestSerializer.HTTPMethodsEncodingParametersInURI.contains(method.rawValue) && parametersJSONSerialization != nil
        let parametersLogFormat = showParameters ? "\nBody: \(parametersJSONSerialization!)" : ""
        
        logInfo?("[REQUEST \(request.pointerString)] : [\(method.rawValue)] \(request.URL!.absoluteString!)\(headersLogFormat)\(parametersLogFormat)")
    }
    
    private func logCancel(method: Method, URLSessionDataTask: NSURLSessionDataTask!, responseObject: NSDictionary?) {
        let responseSerialization = responseObject != nil ? "\nResponse: \(jsonSerializer.string(object: responseObject))" : ""
        
        logInfo?("[DISCARDING CANCELLED REQUEST RESPONSE \(URLSessionDataTask.pointerString)]:[\(method.rawValue)] \(URLSessionDataTask.currentRequest.URL!.absoluteString!) \((URLSessionDataTask.response as! NSHTTPURLResponse).statusCode)")
    }
    
    private func logSuccess(method: Method, request: NSURLRequest, response: NSHTTPURLResponse, responseObject: NSDictionary?) {
        let responseSerialization = jsonSerializer.string(object: responseObject)
        let responseLogFormat = responseSerialization != nil ? "\n\(responseSerialization!)" : ""
        
        let headers = response.allHeaderFields as NSDictionary
        let headersSerialization = jsonSerializer.string(object: headers)
        let headersLogFormat = headersSerialization != nil && count(headersSerialization!) != 0 ? "\nHeaders: \(headersSerialization!)" : ""
        
        logInfo?("[RESPONSE \(request.pointerString)]:[\(method.rawValue)] \(request.URL!.absoluteString!) \(response.statusCode)\(headersLogFormat)\(responseLogFormat)")
    }
    
    private func logFailure(method: Method, request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError?) {
        var responseLogFormat: String = ""
        
        if let data = error?.userInfo?[AFNetworkingOperationFailingURLResponseDataErrorKey] as? NSData {
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                responseLogFormat += "\nBody: " + string
            }
        }
        
        if error != nil {
            responseLogFormat += "\nError: \(error!)"
        }
        
        let headers: NSDictionary? = response != nil ? response!.allHeaderFields as NSDictionary : nil
        let headersSerialization = jsonSerializer.string(object: headers)
        let headersLogFormat = headersSerialization != nil && count(headersSerialization!) != 0 ? "\nHeaders: \(headersSerialization!)" : ""
        
        logWarning?("[RESPONSE \(request.pointerString)]:[\(method.rawValue)] \(request.URL!.absoluteString!) \(response != nil ? response!.statusCode : 0)\(headersLogFormat)\(responseLogFormat)")
    }

}
