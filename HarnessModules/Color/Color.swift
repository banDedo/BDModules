//
//  Color.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class Color {
    
    // MARK:- Grayscale
    
    public class func whiteColor() -> UIColor {
        return grayScale(1.0, alpha: 1.0)
    }

    public class func blackColor() -> UIColor {
        return grayScale(0.0, alpha: 1.0)
    }

    public class func clearColor() -> UIColor {
        return grayScale(1.0, alpha: 0.0)
    }
    
    private class func grayScale(value: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: value, green: value, blue: value, alpha: alpha)
    }

    // MARK:- Accent

    public class func darkBlueColor() -> UIColor {
        return UIColor(red:21.0/255.0, green:27.0/255.0, blue:32.0/255.0, alpha:1.0)
    }

    // MARK:- Domain specific
    
    public class func separatorColor() -> UIColor {
        return UIColor(red:45.0/255.0, green:50.0/255.0, blue:55.0/255.0, alpha:1.0)
    }

}
