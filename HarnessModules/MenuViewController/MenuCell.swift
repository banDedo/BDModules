//
//  MenuCell.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Snap
import UIKit

public protocol MenuCellDelegate: class {
    func menuCell(menuCell: MenuCell, didTapButton sender: UIButton)
}

public class MenuCell: UITableViewCell {
    
    // MARK:- Static Properties
    
    public static var identifier: String = "MenuCell"
    private static var imageWidth = CGFloat(Layout.shortCellIconWidth)
    
    // MARK:- Properties
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRectZero)
        button.titleLabel?.font = Font.headline
        button.setTitleColor(Color.whiteColor, forState: UIControlState.Normal)
        button.setBackgroundColor(Color.darkBlueColor, forControlState: UIControlState.Normal)
        button.setBackgroundColor(Color.blackColor, forControlState: UIControlState.Highlighted)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        button.addTarget(self, action: "handleTap:", forControlEvents: UIControlEvents.TouchUpInside)
        button.exclusiveTouch = true
        return button
        }()
    
    private(set) public lazy var separator: UIView = {
        let separator = UIView(frame: CGRectZero)
        separator.backgroundColor = Color.separatorColor
        return separator
        }()
    
    public weak var delegate: MenuCellDelegate?
    
    // MARK:- Image/Title
    
    public func configureEmpty() {
        separator.hidden = true
        userInteractionEnabled = false
    }
    
    public func configure(imageName: String, title: String) {
        separator.hidden = false
        userInteractionEnabled = true
        
        let image = UIImage(named: imageName + ".png", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!
        let imageWidthOffset = (self.dynamicType.imageWidth - image.size.width)/2.0
        let contentPadding = CGFloat(Layout.shortAnchorPadding)
        let imagePadding = CGFloat(Layout.shortCellImagePadding)
        
        button.setImage(image, forState: UIControlState.Normal)
        button.setTitle(title, forState: UIControlState.Normal)
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0.0, imageWidthOffset + imagePadding, 0.0, contentPadding)
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, imageWidthOffset + imagePadding, 0.0, 0.0)
    }
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.blackColor
        contentView.addSubview(button)
        contentView.addSubview(separator)
        
        button.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        separator.snp_makeConstraints() { make in
            make.top.left.and.right.equalTo(UIEdgeInsetsZero)
            make.height.equalTo(Layout.onePixel)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Action Handlers
    public func handleTap(sender: UIButton) {
        delegate?.menuCell(self, didTapButton: sender)
    }
    
}
