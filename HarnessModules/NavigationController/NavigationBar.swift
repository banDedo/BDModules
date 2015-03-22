//
//  NavigationBar.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class NavigationBar {
    
    public class func configure() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.setBackgroundImage(Color.whiteColor.image(), forBarMetrics: UIBarMetrics.Default)
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.translucent = true
        
        navigationBarAppearance.titleTextAttributes = [
            NSForegroundColorAttributeName: Color.blackColor,
            NSFontAttributeName: Font.headline
        ]
    }
    
}
