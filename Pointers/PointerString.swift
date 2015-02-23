//
//  PointerString.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/30/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Foundation

public extension NSObject {

    public var pointerString: String {
        return NSString(format: "%p", pointerAddress(self)) as! String
    }
    
}

private func pointerAddress<T: AnyObject>(o: T) -> Int {
    return unsafeBitCast(o, Int.self)
}
