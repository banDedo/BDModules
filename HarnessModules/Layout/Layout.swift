//
//  Layout.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class Layout {
    
    // MARK:- Anchored Elements
    
    public static var stackedTextPadding: CGFloat {
        return 0.0
    }
    
    public static var shortAnchorPadding: CGFloat {
        return 10.0
    }

    public static var mediumAnchorPadding: CGFloat {
        return 15.0
    }

    public static var longAnchorPadding: CGFloat {
        return 20.0
    }

    public static var navigationDrawerRevealOffset: CGFloat {
        return 50.0
    }

    // MARK:- Short Cells
    
    public static var shortCellIconWidth: CGFloat {
        return 30.0
    }
    
    public static var shortCellImagePadding: CGFloat {
        return 5.0
    }

    public static var shortCellHeight: CGFloat {
        return 44.0
    }

    // MARK:- Medium Cells

    public static var mediumCellHeight: CGFloat {
        return 54.0
    }

    // MARK:- Large Cells
    
    public static var largeCellHeight: CGFloat {
        return 224.0
    }

    // MARK:- Smallest Dimension
    
    public static var onePixel: CGFloat {
        return 1.0/UIScreen.mainScreen().scale
    }
    
    // MARK:- Profile

    public static var smallProfileImageSize: CGSize {
        return CGSizeMake(30.0, 30.0)
    }

    public static var mediumProfileImageSize: CGSize {
        return CGSizeMake(47.0, 47.0)
    }

    public static var largeProfileImageSize: CGSize {
        return CGSizeMake(95.0, 95.0)
    }
    
    // MARK:- Navigation Bar
    
    public static var navigationBarHeight: CGFloat {
        return 44.0 + statusBarHeight
    }

    public static var statusBarHeight: CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.size.height
    }

    // MARK:- Main screen

    public static var mainScreenBounds: CGRect {
        return UIScreen.mainScreen().bounds
    }

}
