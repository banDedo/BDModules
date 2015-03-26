//
//  NavigationBar.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public protocol MenuNavigationControllerDelegate: class {
    func viewController(viewController: UIViewController, didTapMenuButton: UIButton)
}

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
    
    public class func addMenuButton(#target: UIViewController, action: Selector) {
        target.navigationItem.leftBarButtonItem = {
            let image = UIImage(named: "menu.png")!
            let button = UIButton(frame: CGRectMake(0, 0, image.size.width, image.size.height))
            button.setImage(image, forState: UIControlState.Normal)
            button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
            return UIBarButtonItem(customView: button)
            }()
    }

}
