//
//  ViewGeometry.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/25/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

extension UIView {

    var x: CGFloat {
        get {
            return CGRectGetMinX(frame);
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    var y: CGFloat {
        get {
            return CGRectGetMinY(frame);
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var origin: CGPoint {
        get {
            return CGPointMake(x, y)
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }

    var size: CGSize {
        get {
            return CGSizeMake(width, height)
        }
    }

    var width: CGFloat {
        get {
            return CGRectGetWidth(frame);
        }
    }

    var height: CGFloat {
        get {
            return CGRectGetHeight(frame);
        }
    }

}
