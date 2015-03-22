//
//  ProfileView.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Snap
import UIKit

public class ProfileView: UIView {
    
    // MARK: Injectable
    
    lazy public var rightInset = CGFloat(Layout.navigationDrawerRevealOffset)
    
    // MARK: - Properties
    
    private(set) public lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRectZero)
        backgroundView.backgroundColor = Color.deepBlueColor
        return backgroundView
        }()
    
    private(set) public lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView(frame: CGRectZero)
        profileImageView.layer.borderColor = Color.whiteColor.CGColor
        profileImageView.layer.borderWidth = 2.0
        profileImageView.layer.cornerRadius = self.profileImageViewSize.width/2.0
        profileImageView.layer.masksToBounds = true
        return profileImageView
        }()
    
    private(set) public lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRectZero)
        nameLabel.backgroundColor = Color.clearColor
        nameLabel.textColor = Color.whiteColor
        nameLabel.font = Font.headline
        return nameLabel
        }()
    
    private(set) public lazy var containerView: UIView = {
        let containerView = UIView(frame: CGRectZero)
        containerView.backgroundColor = Color.clearColor
        return containerView
        }()
    
    private var boundView: UIView?
    private var boundViewOffset: CGFloat?
    private var backgroundViewToBottomContraint: Constraint?
    
    private let profileImageViewSize = Layout.largeProfileImageSize
    
    // MARK:- Constructors
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        
        backgroundView.snp_makeConstraints() { make in
            make.top.left.and.right.equalTo(UIEdgeInsetsZero)
        }
        
        containerView.snp_makeConstraints() { make in
            let offset = -self.rightInset/2.0
            make.center.equalTo(CGPointZero).with.offset(CGPointMake(offset, offset))
        }
        
        profileImageView.snp_makeConstraints() { make in
            make.top.equalTo(0.0)
            make.size.equalTo(self.profileImageViewSize)
            make.centerX.equalTo(0.0)
        }
        
        nameLabel.snp_makeConstraints() { make in
            make.top.equalTo(self.profileImageView.snp_bottom).with.offset(Layout.defaultAnchorPadding)
            make.left.greaterThanOrEqualTo(0.0)
            make.right.lessThanOrEqualTo(0.0)
            make.bottom.equalTo(0.0)
            make.centerX.equalTo(self.profileImageView)
        }
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    
    public override func updateConstraints() {
        backgroundViewToBottomContraint?.uninstall()
        if let boundView = self.boundView, boundViewOffset = self.boundViewOffset {
            backgroundView.snp_makeConstraints() { make in
                self.backgroundViewToBottomContraint = make.bottom.equalTo(boundView).with.offset(boundViewOffset)
            }
        }
        
        super.updateConstraints()
    }
    
    public func bindBackgroundViewBottomTo(view: UIView, offset: CGFloat) {
        boundView = view
        boundViewOffset = offset
        updateConstraints()
    }
    
}
