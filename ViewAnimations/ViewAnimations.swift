//
//  UIView.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

private let kDefaultAnimationDuration = 0.2

public extension UIView {
    
    public class func defaultAnimationDuration() -> NSTimeInterval {
        return kDefaultAnimationDuration
    }
    
    public class func animate(
        animate: Bool,
        duration: NSTimeInterval = kDefaultAnimationDuration,
        delay: NSTimeInterval = 0.0,
        options: UIViewAnimationOptions = UIViewAnimationOptions.CurveEaseOut,
        animations: (() -> Void),
        completion: ((Bool) -> Void) = { $0 }) {
            if animate {
                UIView.animateWithDuration(
                    duration,
                    delay: delay,
                    options: options,
                    animations: animations,
                    completion: completion
                )
            } else {
                animations()
                completion(true)
            }
    }
    
}
