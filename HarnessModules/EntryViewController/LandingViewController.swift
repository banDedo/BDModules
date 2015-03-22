//
//  LandingViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Snap
import UIKit

@objc public protocol LandingViewControllerDelegate {
    func landingViewControllerDidLogin(landingViewController: LandingViewController)
}

public class LandingViewController: LifecycleViewController {
    
    // MARK:- Injectable
    
    public lazy var accountUserProvider = AccountUserProvider()
    public lazy var userAPI = UserAPI()
    
    weak public var delegate: LandingViewControllerDelegate?
    
    // MARK:- Properties
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(frame: CGRectZero)
        loginButton.setTitle("Login", forState: UIControlState.Normal)
        loginButton.setBackgroundColor(Color.darkBlueColor, forControlState: UIControlState.Normal)
        loginButton.addTarget(self, action: "handleButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
        return loginButton
        }()
    
    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(loginButton)
        
        loginButton.snp_makeConstraints { make in
            let padding = Layout.defaultAnchorPadding
            make.left.and.right.equalTo(UIEdgeInsetsMake(0.0, padding, 0.0, padding))
            make.height.equalTo(100.0)
            make.centerY.equalTo(0.0)
        }

    }

    public func handleButtonTap(sender: UIButton) {
        userAPI.login(
            email: "tester@test.com",
            password: "testtest",
            userPersistenceHandler: accountUserProvider.userPersistenceHandler()) { [weak self] user, error in
                if let strongSelf = self {
                    if error != nil {
                        let alertController = UIAlertController(
                            title: "Error",
                            message: error!.description,
                            preferredStyle: UIAlertControllerStyle.Alert
                        )
                        
                        alertController.addAction(
                            UIAlertAction(
                                title: "OK",
                                style: UIAlertActionStyle.Cancel) { action in
                                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                            }
                        )
                        
                        strongSelf.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        strongSelf.delegate?.landingViewControllerDidLogin(strongSelf)
                    }
                }
        }
        
    }

}

