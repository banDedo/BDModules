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
        completion: (Bool -> Void) = { $0 }) {
            
            let currentRootViewController: UIViewController? = self.rootViewController
            self.rootViewController = rootViewController
            
            currentRootViewController?.willMoveToParentViewController(nil)
            addChildViewController(rootViewController)
            
            view.addSubview(rootViewController.view)
            rootViewController.view.snp_makeConstraints { make in
                make.edges.equalTo(UIEdgeInsetsZero)
            }
            
            rootViewController.view.alpha = 0.0
            view.layoutIfNeeded()
            
            UIView.animate(
                animated,
                duration: 0.3,
                animations: {
                    currentRootViewController?.view.layer.transform = {
                        let scaleFactor = CGFloat(0.2)
                        var transform = CATransform3DMakeScale(scaleFactor, scaleFactor, 1.0)
                        return transform
                        }()
                    rootViewController.view.alpha = 1.0
                }) { finished in
                    currentRootViewController?.view.removeFromSuperview()
                    
                    rootViewController.didMoveToParentViewController(self)
                    
                    currentRootViewController?.removeFromParentViewController()
                    currentRootViewController?.didMoveToParentViewController(nil)
                    
                    self.setNeedsStatusBarAppearanceUpdate()
                    completion(finished)
            }
            
    }
    
}
