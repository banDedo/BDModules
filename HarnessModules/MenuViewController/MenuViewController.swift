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
    func menuViewController(menuViewController: MenuViewController, didTapLogoutCell: MenuCell)
}

public class MenuViewController: LifecycleViewController, MenuCellDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- Enumerate type
    
    private enum Row: Int {
        case Logout = 0
    }
    
    // MARK:- Properties
    
    private(set) public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.backgroundColor = Color.a7()
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
        delegate?.menuViewController(self, didTapLogoutCell: menuCell)
    }
    
    // MARK: UITableViewDataSource/UITableViewDelegate
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MenuCell.identifier, forIndexPath: indexPath) as! MenuCell
        
        switch Row(rawValue: indexPath.row)! {
        case .Logout:
            cell.button.setTitle("Logout", forState: UIControlState.Normal)
            break
        }
        
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
    
}

public protocol MenuCellDelegate: class {
    func menuCell(menuCell: MenuCell, didTapButton sender: UIButton)
}

public class MenuCell: UITableViewCell {

    // MARK:- Static Properties

    public static var identifier: String = "MenuCell"

    // MARK:- Properties
    
    private(set) public lazy var button: UIButton = {
        let button = UIButton(frame: CGRectZero)
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        button.setTitleColor(Color.a2(), forState: UIControlState.Normal)
        button.setBackgroundColor(Color.a7(), forControlState: UIControlState.Normal)
        button.setBackgroundColor(Color.a6(), forControlState: UIControlState.Highlighted)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        button.addTarget(self, action: "handleTap:", forControlEvents: UIControlEvents.TouchUpInside)
        button.exclusiveTouch = true
        return button
        }()
    
    public weak var delegate: MenuCellDelegate?
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.a6()
        contentView.addSubview(button)
        
        button.snp_makeConstraints() { make in
            make.edges.equalTo(UIEdgeInsetsZero)
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
