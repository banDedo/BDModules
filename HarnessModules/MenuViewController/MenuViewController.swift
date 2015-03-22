//
//  MenuViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 10/24/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import Snap
import UIKit

public protocol MenuViewControllerDelegate: class {
    func menuViewController(menuViewController: MenuViewController, didSelectRow: MenuViewController.Row)
}

public class MenuViewController: LifecycleViewController, MenuCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- Enumerate type
    
    public enum Row: Int {
        case Map = 0
        case Favorites = 1
        case Settings = 2
        case Logout = 3
        case Footer = 4
        
        static var count: Int {
            var max: Int = 0
            while let _ = self(rawValue: ++max) {}
            return max
        }
    }
    
    // MARK: Injectable
    
    public lazy var accountUserProvider = AccountUserProvider()
    
    public var profilePlaceholderImage: UIImage?
    
    private let rightInset = CGFloat(Layout.navigationDrawerRevealOffset)
    private lazy var defaultTopInset: CGFloat = {
        return Layout.mainScreenBounds.size.width - (Layout.statusBarHeight + self.rightInset)
    }()
    
    // MARK:- Properties
    
    private(set) public lazy var profileView: ProfileView = {
        let profileView = ProfileView(frame: CGRectZero)
        return profileView
        }()
    
    private(set) public lazy var tableView: TouchCancelTableView = {
        let tableView = TouchCancelTableView(frame: CGRectZero)
        tableView.contentInset = UIEdgeInsetsMake(self.defaultTopInset, 0.0, 0.0, 0.0)
        tableView.backgroundColor = Color.clearColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.canCancelContentTouches = true
        tableView.panGestureRecognizer.cancelsTouchesInView = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        return tableView
        }()
    
    public weak var delegate: MenuViewControllerDelegate?
    
    private var profileViewToTopConstraint: Constraint?
    
    // MARK:- Cleanup
    
    deinit {
        tableView.dataSource = nil
        tableView.delegate = nil
    }
    
    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = Color.darkBlueColor
        view.addSubview(profileView)
        view.addSubview(tableView)
        
        profileView.bindBackgroundViewBottomTo(view, offset: 0.0)
        
        profileView.snp_makeConstraints() { make in
            make.left.and.right.equalTo(UIEdgeInsetsZero)
            make.height.equalTo(self.profileView.snp_width)
        }
        
        tableView.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        profileView.nameLabel.text = accountUserProvider.user.displayName

        profileView.profileImageView.setImage(
            URLString: accountUserProvider.user.profileImageURL,
            placeholderImage: profilePlaceholderImage,
            animated: true
        )
        
    }
    
    // MARK:- Layout
    
    public override func updateViewConstraints() {
        
        profileViewToTopConstraint?.uninstall()
        profileView.snp_makeConstraints() { make in
            var offset = 0.2 * (self.defaultTopInset + self.tableView.contentOffset.y)
            offset = -max(offset, 0.0)
            self.profileViewToTopConstraint = make.top.equalTo(offset)
        }
        
        profileView.bindBackgroundViewBottomTo(view, offset: -scrollOffset)

        super.updateViewConstraints()
    }
    
    public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    // MARK:- Status Bar
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK:- MenuCellDelegate
    
    public func menuCell(menuCell: MenuCell, didTapButton sender: UIButton) {
        delegate?.menuViewController(self, didSelectRow: row(menuCell))
    }
    
    // MARK: UITableViewDataSource/UITableViewDelegate
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        updateViewConstraints()
        view.layoutIfNeeded()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MenuCell.identifier, forIndexPath: indexPath) as! MenuCell
        
        switch Row(rawValue: indexPath.row)! {
        case .Map:
            cell.configure("menu_feed", title: "Map")
            break
        case .Favorites:
            cell.configure("menu_explore", title: "Favorites")
            break
        case .Settings:
            cell.configure("menu_settings", title: "Settings")
            break
        case .Logout:
            cell.configure("menu_logout", title: "Logout")
            break
        case .Footer:
            cell.configureEmpty()
        }
        
        cell.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch Row(rawValue: indexPath.row)! {
        case .Map, .Favorites, .Settings, .Logout:
            return Layout.shortCellHeight
        case .Footer:
            return footerHeight
        }
    }
    
    public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK:- Accessors
    
    private func row(cell: MenuCell) -> Row {
        return Row(rawValue: cell.tag)!
    }

    private var footerHeight: CGFloat {
        return tableView.height - (defaultTopInset + CGFloat(Row.count - 1) * Layout.shortCellHeight)
    }
    
    private var scrollOffset: CGFloat {
        return defaultTopInset + tableView.contentOffset.y
    }
    
}

public class TouchCancelTableView: UITableView {
    
    public override func touchesShouldCancelInContentView(view: UIView!) -> Bool {
        return true
    }
    
}
