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
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.whiteColor
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
