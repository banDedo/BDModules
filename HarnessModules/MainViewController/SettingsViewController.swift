//
//  SettingsViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 3/22/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import Snap
import UIKit

public class SettingsViewController: LifecycleViewController, SettingsLoggerCellDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK:- Enumerated Type
    
    private enum Row: Int {
        case API = 0
        case ApplicationLifecycle = 1
        case JSON = 2
        case Model = 3
        
        static var count: Int {
            var max: Int = 0
            while let _ = self(rawValue: ++max) {}
            return max
        }
    }
    
    // MARK:- Injectable
    
    public lazy var accountUserProvider = AccountUserProvider()
    public lazy var apiLogger = Logger()
    public lazy var applicationLifecycleLogger = Logger()
    public lazy var jsonLogger = Logger()
    public lazy var modelLogger = Logger()
    public lazy var userDefaults = UserDefaults()

    // MARK:- Properties
    
    private(set) public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.allowsSelection = false
        tableView.delaysContentTouches = true
        tableView.backgroundColor = Color.whiteColor
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(SettingsLoggerCell.self, forCellReuseIdentifier: SettingsLoggerCell.identifier)
        return tableView
        }()
    
    public weak var delegate: MenuNavigationControllerDelegate?
    
    // MARK:- View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loggerSettings = userDefaults.loggerSettings

        title = "Settings"
        view.backgroundColor = Color.whiteColor
        
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBar.addMenuButton(target: self, action: "handleButtonTap:")
    }
    
    // MARK:- Logger Settings
    
    private func updateLoggerSettings(logger: Logger) {
        let loggerSettings = self.loggerSettings
        loggerSettings.updateLogger(logger)
        self.loggerSettings = loggerSettings
    }
    
    // MARK:- Action Handlers
    
    public func handleButtonTap(sender: UIButton) {
        delegate?.viewController(self, didTapMenuButton: sender)
    }

    // MARK:- SettingsLoggerCellDelegate
    
    public func settingsLoggerCell(settingsLoggerCell: SettingsLoggerCell, didToggleSwitch toggleSwitch: UISwitch) {
        let row = Row(rawValue: settingsLoggerCell.tag)!
        let aLogger = logger(row)
        
        aLogger.enabled = toggleSwitch.on
        
        updateLoggerSettings(aLogger)
    }
    
    public func settingsLoggerCell(settingsLoggerCell: SettingsLoggerCell, didUpdateSegmentedControl segmentedControl: UISegmentedControl) {
        let row = Row(rawValue: settingsLoggerCell.tag)!
        let aLogger = logger(row)
        
        let level = Logger.Level(rawValue: segmentedControl.selectedSegmentIndex)!
        aLogger.thresholdLevel = Logger.Level(rawValue: segmentedControl.selectedSegmentIndex)!
        
        updateLoggerSettings(aLogger)
    }

    // MARK:- UITableViewDataSource/UITableViewDelegate
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SettingsLoggerCell.identifier, forIndexPath: indexPath) as! SettingsLoggerCell
        cell.tag = indexPath.row
        cell.delegate = self

        let rowLogger = logger(Row(rawValue: indexPath.row)!)        
        cell.nameLabel.text = rowLogger.tag + " Logger"
        cell.toggleSwitch.on = rowLogger.enabled
        cell.segmentedControl.selectedSegmentIndex = rowLogger.thresholdLevel.rawValue
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 1.0))
        return footerView
    }

    // MARK:- Logger
    
    private func logger(row: Row) -> Logger {
        switch row {
        case .API:
            return apiLogger
        case .ApplicationLifecycle:
            return applicationLifecycleLogger
        case .JSON:
            return jsonLogger
        case .Model:
            return modelLogger
        }
    }
    
    // MARK: Accessors
    
    private var loggerSettings: LoggerSettings! {
        didSet {
            userDefaults.loggerSettings = loggerSettings
        }
    }
    
}

private let kLoggerSettingsMapKey = "kLoggerSettingsMapKey"

private let kLoggerSettingsEnabledKey = "enabled"
private let kLoggerSettingsLevelKey = "level"

public class LoggerSettings: NSObject, NSCoding {

    // MARK:- Properties
    
    private(set) public var map = [ String: [ String: AnyObject ] ]()
    
    // MARK: - Constructor
    
    public override init() { }
    
    // MARK:- NSCoding
    
    public required init(coder aDecoder: NSCoder) {
        map = aDecoder.decodeObjectForKey(kLoggerSettingsMapKey) as! [ String: [ String: AnyObject ] ]
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(map, forKey: kLoggerSettingsMapKey)
    }
    
    // MARK:- Logger Settings
    
    public func isLoggerEnabled(logger: Logger) -> Bool {
        if let isLoggerEnabled = map[logger.tag]?[kLoggerSettingsEnabledKey] as? Bool {
            return isLoggerEnabled
        } else {
            return false
        }
    }

    public func loggerLevel(logger: Logger) -> Logger.Level {
        if let rawValue = map[logger.tag]?[kLoggerSettingsLevelKey] as? Int {
            return Logger.Level(rawValue: rawValue)!
        } else {
            return .Error
        }
    }
    
    public func updateLogger(logger: Logger) {
        var mapValue = map[logger.tag]
        if mapValue == nil {
            mapValue = [ String: AnyObject ]()
        }
        mapValue![kLoggerSettingsEnabledKey] = logger.enabled
        mapValue![kLoggerSettingsLevelKey] = logger.thresholdLevel.rawValue
        map[logger.tag] = mapValue
    }

}
