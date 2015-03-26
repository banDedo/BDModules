//
//  SettingsCell.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/11/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Snap
import UIKit

public protocol SettingsLoggerCellDelegate: class {
    func settingsLoggerCell(settingsLoggerCell: SettingsLoggerCell, didToggleSwitch: UISwitch)
    func settingsLoggerCell(settingsLoggerCell: SettingsLoggerCell, didUpdateSegmentedControl: UISegmentedControl)
}

public class SettingsLoggerCell: UITableViewCell {
    
    // MARK:- Static Properties
    
    public static var identifier: String = "SettingsLoggerCell"

    // MARK:- Properties
    
    private(set) public lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.font = Font.headline
        label.backgroundColor = Color.clearColor
        return label
        }()
    
    private(set) public lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch(frame: CGRectZero)
        toggleSwitch.onTintColor = Color.deepBlueColor
        toggleSwitch.addTarget(self, action: "handleSwitchValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        return toggleSwitch
        }()

    private(set) public lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(frame: CGRectZero)
        segmentedControl.addTarget(self, action: "handleSegmentedControlValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl.tintColor = Color.deepBlueColor
        segmentedControl.setTitleTextAttributes([
            NSForegroundColorAttributeName: Color.deepBlueColor,
            NSFontAttributeName: Font.controlTitle
            ], forState: UIControlState.Normal
        )
        
        var counter: Int = 0
        while let level = Logger.Level(rawValue: counter) {
            segmentedControl.insertSegmentWithTitle(level.description, atIndex: counter, animated: false)
            counter++
        }
        
        return segmentedControl
        }()

    public weak var delegate: SettingsLoggerCellDelegate?
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.whiteColor
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(toggleSwitch)
        contentView.addSubview(segmentedControl)
        
        nameLabel.snp_makeConstraints() { make in
            make.left.equalTo(Layout.mediumAnchorPadding)
            make.top.equalTo(Layout.mediumAnchorPadding)
        }
        
        toggleSwitch.snp_makeConstraints() { make in
            make.left.equalTo(self.nameLabel.snp_right).with.offset(Layout.shortAnchorPadding)
            make.right.equalTo(-Layout.mediumAnchorPadding)
            make.centerY.equalTo(self.nameLabel)
        }

        segmentedControl.snp_makeConstraints() { make in
            make.top.equalTo(self.toggleSwitch.snp_bottom).with.offset(Layout.shortAnchorPadding)
            make.bottom.equalTo(-Layout.mediumAnchorPadding)
            make.left.equalTo(self.nameLabel)
            make.right.equalTo(self.toggleSwitch)
        }

        
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Action Handlers
    
    public func handleSwitchValueChanged(sender: UISwitch) {
        delegate?.settingsLoggerCell(self, didToggleSwitch: sender)
    }
    
    public func handleSegmentedControlValueChanged(sender: UISegmentedControl) {
        delegate?.settingsLoggerCell(self, didUpdateSegmentedControl: sender)
    }
    
    // MARK:- Accessors
    
}
