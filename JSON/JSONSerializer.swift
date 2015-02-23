//
//  JSONSerializer.swift
//  BDModules
//
//  Created by Patrick Hogan on 6/11/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

public class JSONSerializer: NSObject {

    // MARK:- Injectable
    
    public var logWarning: (String -> Void)?

    // MARK:- Serialization

    public func string(object anObject: AnyObject?, options: NSJSONWritingOptions = .allZeros) -> String? {
        if let object: AnyObject = anObject {
            if !object.isKindOfClass(NSArray) && !object.isKindOfClass(NSDictionary) {
                logWarning?("Error creating JSON formatted string from object: \(object).  Not of type NSArray or NSDictionary.");
                return nil
            } else {
            }
            
            var error: NSError?
            let data = NSJSONSerialization.dataWithJSONObject(object, options: options, error: &error)
            
            if error != nil || data == nil {
                logWarning?("Error creating JSON formatted string from: \(object)");
            }
            
            return NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
        } else {
            return nil
        }
    }
    
    public func object(object anObject: AnyObject?, options: NSJSONReadingOptions = .MutableContainers) -> AnyObject? {
        if let object: AnyObject = anObject {
            var data: NSData?
            if object.isKindOfClass(NSData) {
                data = (object as? NSData)
            } else if object.isKindOfClass(NSString) {
                data = (object as? NSString)?.dataUsingEncoding(NSUTF8StringEncoding);
            }
            
            if data != nil {
                var error: NSError?
                var result: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: options, error: &error)
                
                if error != nil {
                    logWarning?("Error parsing JSON object from: \(object)");
                }
                
                return result
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    public func object(#resourceName: String, bundle: NSBundle = NSBundle.mainBundle(), options: NSJSONReadingOptions = .MutableContainers) -> AnyObject? {
        let string = NSString(contentsOfFile: bundle.pathForResource(resourceName, ofType: "json")!, encoding: NSUTF8StringEncoding, error: nil)
        return self.object(object: string, options: options)
    }

}
