//
//  ButtonBackgroundColor.swift
//  BDModules
//
//  Created by Patrick Hogan on 12/6/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forControlState controlState: UIControlState) {
        setBackgroundImage(color.image(), forState: controlState)
    }
    
}
