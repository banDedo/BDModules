//
//  FavoritesViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/11/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

@objc public protocol FavoritesViewControllerDelegate {
    func favoritesViewController(favoritesViewController: FavoritesViewController, didTapMenuButton sender: UIButton)
}

public class FavoritesViewController: LifecycleViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- Enumerate type
    
    public enum Section: Int {
        case Collection = 0
        case Loading = 1
        
        static var count: Int {
            var max: Int = 0
            while let _ = self(rawValue: ++max) {}
            return max
        }
    }

    // MARK:- Injectable
    
    public lazy var accountUserProvider = AccountUserProvider()
    public lazy var favoriteLocationRepository = Repository<Location>()
    public lazy var oAuth2SessionManager = OAuth2SessionManager()
    public lazy var mainFactory = MainFactory()
    
    weak public var delegate: FavoritesViewControllerDelegate?
    
    // MARK:- Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.delaysContentTouches = true
        tableView.backgroundColor = Color.whiteColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(FavoriteLocationCell.self, forCellReuseIdentifier: FavoriteLocationCell.identifier)
        tableView.registerClass(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        return tableView
        }()
    
    private lazy var menuButton: UIBarButtonItem = {
        let image = UIImage(named: "menu.png")!
        let button = UIButton(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        button.setImage(image, forState: UIControlState.Normal)
        button.addTarget(self, action: "handleButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: button)
        }()

    // MARK:- Cleanup
    
    deinit {
    }

    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        view.backgroundColor = Color.whiteColor()

        view.addSubview(tableView)
                
        tableView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = menuButton
    }
    
    // MARK:- UI Update
    
    public func updateUI() {
        switch favoriteLocationRepository.fetchState {
        case .NotFetched:
            break
        case .Fetching:
            break
        case .Fetched:
            break
        case .Error:
            break
        }
        tableView.reloadData()
    }
    
    // MARK:- Favorite Locations
    
    private func fetchFavoriteLocations(handler: ([ Location ]?, NSError?) -> Void = { $0 }) {
        if favoriteLocationRepository.atEnd {
            return
        }
        
        favoriteLocationRepository.fetch() { [weak self] locations, error in
            if let strongSelf = self {
                if error != nil {
                    let alertController = UIAlertController(
                        title: "Error",
                        message: error!.description,
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    
                    alertController.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: UIAlertActionStyle.Cancel) { action in
                                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                        }
                    )
                    
                    strongSelf.presentViewController(alertController, animated: true, completion: nil)
                }
                strongSelf.updateUI()
                handler(locations, error)
            }
        }
    }
    
    // MARK:- Action Handlers
    
    public func handleButtonTap(sender: UIButton) {
        delegate?.favoritesViewController(self, didTapMenuButton: sender)
    }
    
    // MARK:- Status Bar
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }

    // MARK:- UITableViewDataSource/UITableViewDelegate
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Collection:
            return favoriteLocationRepository.elementCount
        case .Loading:
            return favoriteLocationRepository.atEnd ? 0 : 1
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .Collection:
            let cell = tableView.dequeueReusableCellWithIdentifier(FavoriteLocationCell.identifier, forIndexPath: indexPath) as! FavoriteLocationCell
            
            cell.textLabel?.font = Font.headline()
            cell.detailTextLabel?.font = Font.paragraph()
            
            let location = favoriteLocationRepository.elements[indexPath.row]
            cell.textLabel?.text = location.title
            cell.detailTextLabel?.text = location.subtitle
            
            return cell
        case .Loading:
            let cell = tableView.dequeueReusableCellWithIdentifier(LoadingCell.identifier, forIndexPath: indexPath) as! LoadingCell
            cell.activityIndicatorView.startAnimating()
            fetchFavoriteLocations()
            return cell
        }
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

public class FavoriteLocationCell: UITableViewCell {
    
    // MARK:- Static Properties
    
    public static var identifier: String = "FavoriteLocationCell"
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Color.whiteColor()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

public class LoadingCell: UITableViewCell {
    
    // MARK:- Static Properties
    
    public static var identifier: String = "LoadingCell"
    
    // MARK:- Properties
    
    private(set) public lazy var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    // MARK:- Constructors
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Color.whiteColor()
        contentView.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp_makeConstraints() { make in
            make.center.equalTo(CGPointZero)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
