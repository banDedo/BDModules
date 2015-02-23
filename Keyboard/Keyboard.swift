//
//  Keyboard.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/11/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class KeyboardTracker: NSObject {
    
    // MARK:- Enumerated Types

    public enum State: Int {
        case Hiding
        case Presenting
        case Presented
        case ChangingFrame
        case ChangedFrame
        case Dismissing
        case Dismissed
    }
    
    // MARK:- Properties

    public var beginFrame = CGRectNull
    public var endFrame = CGRectNull
    public var animationDuration = NSTimeInterval(0.0)
    public var animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(0)
    
    private(set) public var state: State
    dynamic private(set) public var backingState: Int = State.Hiding.rawValue {
        willSet {
            state = State(rawValue: newValue)!
        }
    }
    
    public var keyboardHeight: CGFloat {
        get {
            return state == .Dismissed || state == .Hiding ? 0.0 : endFrame.height;
        }
    }
    
    // MARK:- Cleanup
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    // MARK:- Constructor

    public init(notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()) {
        self.notificationCenter = notificationCenter
        state = State(rawValue: backingState)!
        super.init()

        notificationCenter.addObserver(
            self,
            selector:"keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil)

        notificationCenter.addObserver(
            self,
            selector:"keyboardDidShow:",
            name: UIKeyboardDidShowNotification,
            object: nil)

        notificationCenter.addObserver(
            self,
            selector:"keyboardWillChangeFrame:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)

        notificationCenter.addObserver(
            self,
            selector:"keyboardDidChangeFrame:",
            name: UIKeyboardWillChangeFrameNotification,
            object: nil)

        notificationCenter.addObserver(
            self,
            selector:"keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
        
        notificationCenter.addObserver(
            self,
            selector:"keyboardDidHide:",
            name: UIKeyboardDidHideNotification,
            object: nil)
    }

    // MARK:- NSNotificationCenter

    func keyboardWillShow(notification: NSNotification) {
        (beginFrame, endFrame, animationDuration, animationCurve) = parseInfo(notification)
        state = .Presenting
    }

    func keyboardDidShow(notification: NSNotification) {
        (beginFrame, endFrame, animationDuration, animationCurve) = parseInfo(notification)
        state = .Presented
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        switch state {
        case .Hiding:
            return
        case .Presenting:
            return
        case .Presented:
            break
        case .ChangingFrame:
            break
        case .ChangedFrame:
            break
        case .Dismissing:
            return
        case .Dismissed:
            return
        }
        
        (beginFrame, endFrame, animationDuration, animationCurve) = parseInfo(notification)
        state = .ChangingFrame
    }

    func keyboardDidChangeFrame(notification: NSNotification) {
        switch state {
        case .Hiding:
            return
        case .Presenting:
            return
        case .Presented:
            break
        case .ChangingFrame:
            break
        case .ChangedFrame:
            break
        case .Dismissing:
            return
        case .Dismissed:
            return
        }
        
        (beginFrame, endFrame, animationDuration, animationCurve) = parseInfo(notification)
        state = .ChangedFrame
    }

    func keyboardWillHide(notification: NSNotification) {
        (beginFrame, endFrame, animationDuration, animationCurve) = parseInfo(notification)
        state = .Dismissing
    }
    
    func keyboardDidHide(notification: NSNotification) {
        (beginFrame, endFrame, animationDuration, animationCurve) = parseInfo(notification)
        state = .Dismissed
    }

    // MARK:- Private
    
    private let notificationCenter: NSNotificationCenter

    private func parseInfo(notification: NSNotification) -> (CGRect, CGRect, NSTimeInterval, UIViewAnimationOptions) {
        return (
            (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue(),
            (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue(),
            (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue,
            UIViewAnimationOptions((notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedLongValue << 16)
        )
    }
    
}
