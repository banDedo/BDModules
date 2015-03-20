//
//  ContainerViewController.h
//  BDModules
//
//  Created by Patrick Hogan on 10/25/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Snap
import UIKit

private var ViewControllerAssociationHandle: UInt8 = 0

public extension UIViewController {
    
    // MARK:- Public Properties
    
    public var rootViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &ViewControllerAssociationHandle) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &ViewControllerAssociationHandle, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    // MARK:- Root VC Presentation
    
    public func replaceRootViewController(
        rootViewController: UIViewController,
        animated: Bool = false,
        completion: (Bool -> Void)? = nil) {
        
        let currentRootViewController: UIViewController? = self.rootViewController
        self.rootViewController = rootViewController
        
        if (animated && currentRootViewController != nil) {
            transitionFromViewController(
                currentRootViewController!,
                toViewController: rootViewController,
                duration: 0.2,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: nil) { [weak self] finished in
                    if let strongSelf = self {
                        strongSelf.setNeedsStatusBarAppearanceUpdate()
                        completion?(finished)
                    }
            }
        } else {
            if currentRootViewController != nil {
                currentRootViewController!.willMoveToParentViewController(nil)
            }
            
            addChildViewController(rootViewController)
            view.addSubview(rootViewController.view)
            
            rootViewController.view.snp_makeConstraints { make in
                make.edges.equalTo(UIEdgeInsetsZero)
            }
            
            if currentRootViewController != nil {
                currentRootViewController!.view.removeFromSuperview()
            }
            
            rootViewController.didMoveToParentViewController(self)
            
            if currentRootViewController != nil {
                currentRootViewController!.removeFromParentViewController()
                currentRootViewController!.didMoveToParentViewController(nil)
            }
            
            setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
}
