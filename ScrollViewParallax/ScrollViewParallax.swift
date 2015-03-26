//
//  ScrollViewParallax.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/25/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Snap
import UIKit

@objc public protocol ScrollViewParallaxDelegate {
    func defaultTopInsetForScrollViewParallax(scrollViewParallax: ScrollViewParallax) -> CGFloat
    func contentHeightForScrollViewParallax(scrollViewParallax: ScrollViewParallax) -> CGFloat
}

public class ScrollViewParallax: NSObject {

    // MARK:- Injectable
    
    public var parallaxFactor = CGFloat(0.2)
    
    // MARK:- Properties
    
    public var parallaxContentView: UIView
    public var parallaxBackgroundView: UIView?
    public var scrollView: UIScrollView
    public var containerView: UIView
    
    private var backgroundViewToBottomContraint: Constraint?
    private var parallaxViewToTopConstraint: Constraint?

    public weak var delegate: ScrollViewParallaxDelegate?
    
    // MARK:- Constructor
    
    public init(
        parallaxContentView: UIView,
        parallaxBackgroundView: UIView?,
        scrollView: UIScrollView,
        containerView: UIView,
        delegate: ScrollViewParallaxDelegate) {
            self.parallaxContentView = parallaxContentView
            self.parallaxBackgroundView = parallaxBackgroundView
            self.scrollView = scrollView
            self.containerView = containerView
            self.delegate = delegate
            super.init()
            
            containerView.addSubview(parallaxContentView)
            containerView.addSubview(scrollView)
            
            parallaxBackgroundView?.snp_makeConstraints() { make in
                make.top.left.and.right.equalTo(UIEdgeInsetsZero)
            }
            
            parallaxContentView.snp_makeConstraints() { make in
                make.left.and.right.equalTo(UIEdgeInsetsZero)
                make.height.equalTo(self.parallaxContentView.snp_width)
            }
            
            scrollView.snp_makeConstraints() { make in
                make.edges.equalTo(UIEdgeInsetsZero)
            }
    }
    
    // MARK:- Layout
    
    public func updateConstraints() {
        if let defaultTopInset = delegate?.defaultTopInsetForScrollViewParallax(self) {
            parallaxViewToTopConstraint?.uninstall()
            parallaxContentView.snp_makeConstraints() { make in
                var offset = self.parallaxFactor * (defaultTopInset + self.scrollView.contentOffset.y)
                offset = -max(offset, 0.0)
                self.parallaxViewToTopConstraint = make.top.equalTo(offset)
            }
            
            backgroundViewToBottomContraint?.uninstall()
            let boundViewOffset = -defaultTopInset - min(0.0, scrollOffset)
            parallaxBackgroundView?.snp_makeConstraints() { make in
                self.backgroundViewToBottomContraint = make.bottom.equalTo(self.containerView).with.offset(boundViewOffset)
            }
        }
    }
    
    public func updateScrollViewContentInset() {
        if let defaultTopInset = delegate?.defaultTopInsetForScrollViewParallax(self), let contentHeight = delegate?.contentHeightForScrollViewParallax(self) {
            scrollView.contentInset = UIEdgeInsetsMake(
                defaultTopInset,
                0.0,
                min(-(defaultTopInset + contentHeight), 0.0),
                0.0
            )
        }
    }

    private var scrollOffset: CGFloat {
        if let defaultTopInset = delegate?.defaultTopInsetForScrollViewParallax(self) {
            return defaultTopInset + scrollView.contentOffset.y
        } else {
            return scrollView.contentOffset.y
        }
    }
    
}
