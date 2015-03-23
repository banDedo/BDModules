//
//  FavoriteLocationCell.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/11/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Snap
import UIKit

public class FavoriteLocationCell: UITableViewCell {
    
    // MARK:- Static Properties
    
    public static var identifier: String = "FavoriteLocationCell"
    
    // MARK:- Properties
    
    private(set) public var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: CGRectZero)
        backgroundImageView.clipsToBounds = true
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        return backgroundImageView
    }()

    private(set) public var blurView: BlurView = {
        let blurView = BlurView(style: UIBlurEffectStyle.Dark)
        return blurView
        }()

    private(set) public lazy var primaryLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.font = Font.headline
        label.backgroundColor = Color.clearColor
        label.textColor = Color.whiteColor
        return label
        }()

    private(set) public lazy var secondaryLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.font = Font.paragraph
        label.backgroundColor = Color.clearColor
        label.textColor = Color.whiteColor
        return label
        }()

    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(blurView)
        blurView.addSubview(primaryLabel)
        blurView.addSubview(secondaryLabel)
        
        backgroundImageView.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        blurView.snp_makeConstraints() { make in
            make.bottom.left.and.right.equalTo(UIEdgeInsetsZero)
        }

        let insets = UIEdgeInsetsMake(
            Layout.shortAnchorPadding,
            Layout.mediumAnchorPadding,
            Layout.shortAnchorPadding,
            Layout.mediumAnchorPadding
        )

        primaryLabel.snp_makeConstraints() { make in
            make.top.equalTo(insets)
            make.left.equalTo(insets)
            make.right.lessThanOrEqualTo(-insets.right)
        }

        secondaryLabel.snp_makeConstraints() { make in
            make.left.and.bottom.equalTo(insets)
            make.right.lessThanOrEqualTo(-insets.right)
            make.top.equalTo(self.primaryLabel.snp_bottom).with.offset(Layout.stackedTextPadding)
        }
    
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
