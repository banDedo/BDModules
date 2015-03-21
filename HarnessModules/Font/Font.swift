//
//  Font.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class Font {
    
    // MARK:- Greyscale
    
    public class func headline() -> UIFont {
        return UIFont(name: "Avenir-Book", size: 16)!
    }

    public class func paragraph() -> UIFont {
        return UIFont(name: "AvenirNext-UltraLight", size: 12)!
    }

    public class func roundedButtonTitle() -> UIFont {
        return UIFont(name: "Avenir-Book", size: 13)!
    }

    public class func formField() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 13)!
    }

}
