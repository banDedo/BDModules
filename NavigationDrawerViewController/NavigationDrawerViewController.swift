//
//  NavigationDrawerViewController.swift
//  Harness
//
//  Created by Patrick Hogan on 3/17/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Snap
import UIKit

public let kNavigationDrawerDefaultRevealOffset = CGFloat(50.0)

public class NavigationDrawerViewController: LifecycleViewController, UIGestureRecognizerDelegate {

    // MARK:- Enumerated Types
    
    public enum Orientation {
        case Default
        case PartialRevealLeft
        case RevealLeft
    }

    private enum ViewControllerIndex: Int {
        case Left = 0
        case Center = 1

        static var count: Int {
            var max: Int = 0
            while let _ = self(rawValue: ++max) {}
            return max
        }
    }

    // MARK:- Properties
    
    public var leftDrawerPartialRevealHorizontalOffset = CGFloat(kNavigationDrawerDefaultRevealOffset) {
        didSet {
            if !isDragging {
                switch orientation {
                case .PartialRevealLeft:
                    updateViewConstraints()
                    break
                case .Default, .RevealLeft:
                    break
                }
            }
        }
    }
    
    private(set) public var centerViewController: UIViewController?
    private(set) public var leftDrawerViewController: UIViewController?
    
    private(set) public lazy var statusBarBlockerView: UIView = {
        let statusBarBlockerView = UIView(frame: CGRectZero)
        statusBarBlockerView.backgroundColor = UIColor.blackColor()
        return statusBarBlockerView
        }()
    
    public var animationDuration = NSTimeInterval(0.25)
    public var shortAnimationDuration = NSTimeInterval(0.15)
    
    public var minimumLeftContainerOffset = CGFloat(-kNavigationDrawerDefaultRevealOffset)
    
    private(set) public var orientation = Orientation.Default
    
    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        for containerView in containerViews {
            view.addSubview(containerView)
        }
        
        view.addSubview(statusBarBlockerView)

        leftContainerView.snp_makeConstraints() { make in
            make.top.and.bottom.equalTo(UIEdgeInsetsZero);
            make.width.equalTo(self.view);
        }

        centerContainerView.snp_makeConstraints() { make in
            make.top.and.bottom.equalTo(UIEdgeInsetsZero);
            make.width.equalTo(self.view);
        }

        blockingView.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        statusBarBlockerView.snp_makeConstraints() { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(UIApplication.sharedApplication().statusBarFrame.size.height)
        }
        
    }
    
    // MARK:- Layout
    
    public override func updateViewConstraints() {
        centerContainerViewHorizontalOffsetConstraint?.uninstall()
        leftContainerViewHorizontalOffsetConstraint?.uninstall()

        centerContainerView.snp_makeConstraints() { make in
            self.centerContainerViewHorizontalOffsetConstraint = {
                if self.isDragging {
                    var currentHorizontalOffset = self.currentHorizontalOffset
                    if fabs(self.currentPanDelta!.x) > fabs(self.currentPanDelta!.y) {
                        currentHorizontalOffset -= self.currentPanDelta!.x
                        currentHorizontalOffset = max(0.0, currentHorizontalOffset)
                        currentHorizontalOffset = min(self.view.frame.size.width, currentHorizontalOffset)
                    }
                    return make.centerX.equalTo(self.view.snp_centerX).with.offset(currentHorizontalOffset)
                } else {
                    switch self.orientation {
                    case .Default:
                        return make.left.equalTo(0.0)
                    case .PartialRevealLeft:
                        return make.left.equalTo(self.view.snp_right).with.offset(-self.leftDrawerPartialRevealHorizontalOffset)
                    case .RevealLeft:
                        return make.left.equalTo(self.view.snp_right)
                    }
                }
            }()
        }
        
        leftContainerView.snp_makeConstraints() { make in
            self.leftContainerViewHorizontalOffsetConstraint = {
                if self.isDragging {
                    var currentLeftContainerOffset = (1.0 - self.normalizedCenterViewOffset) * self.minimumLeftContainerOffset
                    currentLeftContainerOffset = max(currentLeftContainerOffset, self.minimumLeftContainerOffset)
                    currentLeftContainerOffset = min(currentLeftContainerOffset, 0.0)
                    return make.left.equalTo(self.view.snp_left).with.offset(currentLeftContainerOffset)
                } else {
                    switch self.orientation {
                    case .Default:
                        return make.left.equalTo(self.minimumLeftContainerOffset)
                    case .PartialRevealLeft, .RevealLeft:
                        return make.left.equalTo(0.0)
                    }
                }
                }()
        }
        super.updateViewConstraints()
    }
    
    public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    // MARK: Status Bar
    
    func updateStatusBarBlockerView() {
        statusBarBlockerView.alpha = min(normalizedCenterViewOffset, 1.0)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Blocking View
    
    func updateBlockingView() {
        switch orientation {
        case .Default:
            blockingView.hidden = true
            break
        case .PartialRevealLeft, .RevealLeft:
            blockingView.hidden = false
            break
        }
    }
    
    // MARK:- Child View Controllers

    public func replaceCenterViewController(viewController: UIViewController) {
        replaceCenterViewController({ return viewController })
    }
    
    public func replaceCenterViewController(
        handler: Void -> UIViewController,
        animated: Bool = false,
        completion: Bool -> Void = { $0 }) {
            view.userInteractionEnabled = false
            
            let child = centerViewController
            
            var completionHandler: (Bool -> Void) = { $0 }
            let replacementHandler: Void -> Void = { [weak self] in
                if let strongSelf = self {
                    var viewController = handler()
                    child?.willMoveToParentViewController(nil)
                    strongSelf.addChildViewController(viewController)
                    
                    strongSelf.centerContainerView.insertSubview(
                        viewController.view,
                        belowSubview:child?.view ?? strongSelf.blockingView
                    )
                    
                    viewController.view.snp_makeConstraints() { make in
                        make.edges.equalTo(strongSelf.centerContainerView)
                    }
                    
                    strongSelf.centerContainerView.layoutIfNeeded()
                    
                    completionHandler = { [weak self] finished in
                        if let strongSelf = self {
                            strongSelf.view.userInteractionEnabled = true
                            strongSelf.blockingView.hidden = true
                            
                            child?.removeFromParentViewController()
                            viewController.didMoveToParentViewController(strongSelf)
                            
                            strongSelf.centerViewController = viewController
                            completion(finished)
                        }
                    }
                }
            }
                        
            if !animated {
                replacementHandler()
                child?.view.removeFromSuperview()
                completionHandler(true)
                updateViewConstraints()
                view.layoutIfNeeded()
                updateStatusBarBlockerView()
            } else {
                view.layoutIfNeeded()
                UIView.animate(
                    true,
                    duration: shortAnimationDuration,
                    animations: {
                        self.orientation = .RevealLeft
                        self.updateViewConstraints()
                        self.view.layoutIfNeeded()
                    }) { [weak self] finished in
                        if let strongSelf = self {
                            let minimumDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(strongSelf.shortAnimationDuration * Double(NSEC_PER_SEC)))
                            
                            replacementHandler()
                            child?.view.removeFromSuperview()
                            
                            dispatch_after(minimumDelay, dispatch_get_main_queue()) { [weak self] in
                                if let strongSelf = self {
                                    UIView.animate(
                                        true,
                                        duration: strongSelf.animationDuration,
                                        animations: { [weak self] in
                                            strongSelf.orientation = .Default
                                            strongSelf.updateViewConstraints()
                                            strongSelf.view.layoutIfNeeded()
                                            strongSelf.updateStatusBarBlockerView()
                                        },
                                        completion: completionHandler
                                    )
                                }
                            }
                        }
                }
            }
        
    }
    
    public func replaceLeftViewController(viewController: UIViewController) {
        view.userInteractionEnabled = false
        
        let child = leftDrawerViewController
        child?.willMoveToParentViewController(nil)
        child?.view.removeFromSuperview()
        
        addChildViewController(viewController)
        leftContainerView.addSubview(viewController.view)
        viewController.view.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        child?.removeFromParentViewController()
        viewController.didMoveToParentViewController(self)
        
        leftDrawerViewController = viewController
        updateViewConstraints()
        view.layoutIfNeeded()
        updateStatusBarBlockerView()
    }
    
    // MARK:- Anchor Drawer
    
    public func anchorDrawer(
        orientation: Orientation,
        animated: Bool,
        completion: Bool -> Void = { finished in }) {
            let animations: Void -> Void = {
                self.orientation = orientation
                self.updateViewConstraints()
                self.view.layoutIfNeeded()
                self.updateStatusBarBlockerView()
            }
            
            let completionHandler: Bool -> Void = { [weak self] finished in
                if let strongSelf = self {
                    strongSelf.updateBlockingView()
                    completion(finished)
                }
            }
            
            UIView.animate(
                animated,
                duration: animationDuration,
                animations: animations,
                completion: completionHandler
            )
    }
    
    // MARK:- Action Handlers
    
    public func handlePan(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        switch sender.state {
        case UIGestureRecognizerState.Began:

            currentPanDelta = CGPointZero
            currentTouchPoint = location
            
            isDragging = true
            
            break
            
        case UIGestureRecognizerState.Changed:
            
            currentPanDelta = CGPointMake(
                currentTouchPoint!.x - location.x,
                currentTouchPoint!.y - location.y
            )
            
            currentTouchPoint = location
            
            updateViewConstraints()
            view.layoutIfNeeded()
            
            break
            
        case UIGestureRecognizerState.Ended, UIGestureRecognizerState.Cancelled:
            
            isDragging = false
            
            let thresholdSpeed = CGFloat(100.0)
            let currentVelocity = sender.velocityInView(view)
            
            let orientation: Orientation
            if fabs(currentVelocity.x) > thresholdSpeed {
                if currentVelocity.x > 0.0 {
                    orientation = .PartialRevealLeft
                } else {
                    orientation = .Default
                }
            } else {
                if currentHorizontalOffset > leftDrawerPartialRevealHorizontalOffset {
                    orientation = .PartialRevealLeft
                } else {
                    orientation = .Default
                }
            }
            
            anchorDrawer(orientation, animated: true)

            break
            
        case UIGestureRecognizerState.Failed, UIGestureRecognizerState.Possible:
            break
        }
        
        updateStatusBarBlockerView()
    }
    
    public func handleTap(sender: UITapGestureRecognizer) {
        anchorDrawer(.Default, animated: true)
    }

    // MARK:- Private Properties
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.delegate = self
        return panGestureRecognizer
        }()
    
    private lazy var blockingView: UIView = {
        let blockingView = UIView(frame: CGRectZero)
        blockingView.backgroundColor = UIColor.clearColor()
        blockingView.hidden = true
        blockingView.addGestureRecognizer({
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            tapGestureRecognizer.numberOfTapsRequired = 1
            tapGestureRecognizer.numberOfTouchesRequired = 1
            tapGestureRecognizer.delegate = self
            tapGestureRecognizer.requireGestureRecognizerToFail(self.panGestureRecognizer)
            return tapGestureRecognizer
            }())
        return blockingView
        }()
    
    private lazy var containerViews: [ UIView ] = {
        var containerViews = [ UIView ]()
        for i in 0..<ViewControllerIndex.count {
            let view = UIView(frame: CGRectZero)
            view.backgroundColor = UIColor.blackColor()
            view.opaque = true
            
            let viewControllerIndex = ViewControllerIndex(rawValue: i)!
            switch viewControllerIndex {
            case .Left:
                break
            case .Center:
                view.addGestureRecognizer(self.panGestureRecognizer)
                view.addSubview(self.blockingView)
                break
            }
            
            containerViews.append(view)
        }
        return containerViews
        }()

    private lazy var leftContainerView: UIView = {
        return self.containerViews[ViewControllerIndex.Left.rawValue]
        }()
    
    private var centerContainerView: UIView {
        return self.containerViews[ViewControllerIndex.Center.rawValue]
    }
    
    // MARK:- Panning Properties
    
    private var isDragging = false
    
    private var currentTouchPoint: CGPoint?
    private var currentPanDelta: CGPoint?
    private var centerContainerViewHorizontalOffsetConstraint: Constraint?
    private var leftContainerViewHorizontalOffsetConstraint: Constraint?
    
    private var currentHorizontalOffset: CGFloat {
        return CGRectGetMinX(centerContainerView.frame)
    }
    
    private var normalizedCenterViewOffset: CGFloat {
        var normalizedCenterViewOffset = self.currentHorizontalOffset
        normalizedCenterViewOffset /= (view.frame.size.width - self.leftDrawerPartialRevealHorizontalOffset)
        return normalizedCenterViewOffset
    }
    
}
