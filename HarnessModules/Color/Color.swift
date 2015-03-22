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
    
    public static var whiteColor: UIColor {
        return grayScale(1.0, alpha: 1.0)
    }

    public static var blackColor: UIColor {
        return grayScale(0.0, alpha: 1.0)
    }

    public static var clearColor: UIColor {
        return grayScale(1.0, alpha: 0.0)
    }
    
    private class func grayScale(value: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: value, green: value, blue: value, alpha: alpha)
    }

    // MARK:- Accent

    public static var deepBlueColor: UIColor {
        return UIColor(red:20.0/255.0, green:45.0/255.0, blue:70.0/255.0, alpha:1.0)
    }

    public static var darkBlueColor: UIColor {
        return UIColor(red:21.0/255.0, green:27.0/255.0, blue:32.0/255.0, alpha:1.0)
    }

    // MARK:- Domain specific
    
    public static var separatorColor: UIColor {
        return UIColor(red:45.0/255.0, green:50.0/255.0, blue:55.0/255.0, alpha:1.0)
    }

}
