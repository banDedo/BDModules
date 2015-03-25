//
//  ViewGeometry.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/25/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public extension UIView {

    public var x: CGFloat {
        get {
            return CGRectGetMinX(frame);
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    public var y: CGFloat {
        get {
            return CGRectGetMinY(frame);
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    public var origin: CGPoint {
        get {
            return CGPointMake(x, y)
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }

    public var size: CGSize {
        get {
            return CGSizeMake(width, height)
        }
    }

    public var width: CGFloat {
        get {
            return CGRectGetWidth(frame);
        }
    }

    public var height: CGFloat {
        get {
            return CGRectGetHeight(frame);
        }
    }

}
