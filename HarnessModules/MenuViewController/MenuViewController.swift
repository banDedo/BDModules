//
//  MenuViewController
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
        case Logout = 2
        
        static var count: Int {
            var max: Int = 0
            while let _ = self(rawValue: ++max) {}
            return max
        }
    }
    
    // MARK:- Properties
    
    private(set) public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.delaysContentTouches = true
        tableView.backgroundColor = Color.darkBlueColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        return tableView
        }()
    
    public weak var delegate: MenuViewControllerDelegate?
    
    // MARK:- Cleanup
    
    deinit {
        tableView.dataSource = nil
        tableView.delegate = nil
    }
    
    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
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
        case .Logout:
            cell.configure("menu_logout", title: "Logout")
            break
        }
        
        cell.tag = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
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
    
    // MARK:- Accessors
    
    private func row(cell: MenuCell) -> Row {
        return Row(rawValue: cell.tag)!
    }
    
}

public protocol MenuCellDelegate: class {
    func menuCell(menuCell: MenuCell, didTapButton sender: UIButton)
}

public class MenuCell: UITableViewCell {

    // MARK:- Static Properties

    public static var identifier: String = "MenuCell"
    private static var imageWidth = CGFloat(30.0)

    // MARK:- Properties
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRectZero)
        button.titleLabel?.font = Font.headline()
        button.setTitleColor(Color.whiteColor(), forState: UIControlState.Normal)
        button.setBackgroundColor(Color.darkBlueColor(), forControlState: UIControlState.Normal)
        button.setBackgroundColor(Color.blackColor(), forControlState: UIControlState.Highlighted)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        button.addTarget(self, action: "handleTap:", forControlEvents: UIControlEvents.TouchUpInside)
        button.exclusiveTouch = true
        return button
        }()
    
    private(set) public lazy var separator: UIView = {
        let separator = UIView(frame: CGRectZero)
        separator.backgroundColor = Color.separatorColor()
        return separator
        }()
    
    public weak var delegate: MenuCellDelegate?
    
    // MARK:- Image/Title
    
    public func configure(imageName: String, title: String) {
        let image = UIImage(named: imageName)!
        let imageWidthOffset = (self.dynamicType.imageWidth - image.size.width)/2.0
        let contentPadding = CGFloat(10.0)
        let imagePadding = CGFloat(5.0)
        
        button.setImage(image, forState: UIControlState.Normal)
        button.setTitle(title, forState: UIControlState.Normal)
        
        button.contentEdgeInsets = UIEdgeInsetsMake(0.0, imageWidthOffset + imagePadding, 0.0, contentPadding)
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, imageWidthOffset + imagePadding, 0.0, 0.0)
    }
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.blackColor()
        contentView.addSubview(button)
        contentView.addSubview(separator)
        
        button.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
        
        separator.snp_makeConstraints() { make in
            make.top.left.and.right.equalTo(UIEdgeInsetsZero)
            make.height.equalTo(1.0/UIScreen.mainScreen().scale)
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
