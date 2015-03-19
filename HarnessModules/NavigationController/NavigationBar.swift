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
        navigationBarAppearance.barTintColor = Color.a6()
        navigationBarAppearance.translucent = false
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes(
            [ NSForegroundColorAttributeName: Color.a2(), NSFontAttributeName: UIFont.boldSystemFontOfSize(14) ],
            forState: UIControlState.Normal
        )
    }
    
}
