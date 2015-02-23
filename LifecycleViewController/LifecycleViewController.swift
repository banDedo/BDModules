//
//  LifecycleViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class LifecycleViewController: UIViewController {
    
    // MARK:- Lifecycle State

    public enum LifecycleState: String {
        case NotLoaded = "Not Loaded"
        case Loaded = "Loaded"
        case Appearing = "Appearing"
        case Appeared = "Appeared"
        case Disappearing = "Disappearing"
        case Disappeared = "Disappeared"
    }
    
    // MARK:- Public Properties

    public var lifecycleState: LifecycleState = .NotLoaded

    // MARK:- View lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        lifecycleState = .Loaded
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        lifecycleState = .Appearing
    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        lifecycleState = .Appeared
    }

    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        lifecycleState = .Disappearing
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycleState = .Disappeared
    }
    
}
