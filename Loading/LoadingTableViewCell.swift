//
//  LoadingTableViewCell.swift
//  Harness
//
//  Created by Patrick Hogan on 3/21/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Snap
import UIKit

public class LoadingCell: UITableViewCell {
    
    // MARK:- Static Properties
    
    public static var identifier: String = "LoadingCell"
    
    // MARK:- Properties
    
    private(set) public lazy var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.whiteColor
        contentView.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp_makeConstraints() { make in
            make.center.equalTo(CGPointZero)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

