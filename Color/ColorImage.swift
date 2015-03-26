//
//  ButtonBackgroundColor.swift
//  BDModules
//
//  Created by Patrick Hogan on 12/6/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public extension UIColor {
    
    public func image(size: CGSize = CGSizeMake(1, 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let currentContext = UIGraphicsGetCurrentContext()
        
        let fillRect = CGRectMake(0, 0, size.width, size.height)
        CGContextSetFillColorWithColor(currentContext, CGColor)
        
        CGContextFillRect(currentContext, fillRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result
    }
    
}
