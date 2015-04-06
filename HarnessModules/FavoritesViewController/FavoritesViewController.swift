//
//  FavoritesViewController.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/11/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

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
    public lazy var imageViewLazyLoader = ImageViewLazyLoader()
    public lazy var favoriteLocationRepository = Repository<Location>()
    public lazy var oAuth2SessionManager = OAuth2SessionManager()
    public lazy var mainFactory = MainFactory()
    
    weak public var delegate: MenuNavigationControllerDelegate?
    
    // MARK:- Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero)
        tableView.allowsSelection = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delaysContentTouches = true
        tableView.backgroundColor = Color.whiteColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(FavoriteLocationCell.self, forCellReuseIdentifier: FavoriteLocationCell.identifier)
        tableView.registerClass(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        return tableView
        }()
    
    // MARK:- Cleanup
    
    deinit {
        tableView.dataSource = nil
        tableView.delegate = nil
    }

    // MARK:- View lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        view.backgroundColor = Color.whiteColor
        view.addSubview(tableView)
                
        tableView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBar.addMenuButton(target: self, action: "handleButtonTap:")
    }
    
    // MARK:- UI Update
    
    public func updateUI(animated: Bool = false, newElements: [ Location ]? = nil) {
        if animated && newElements != nil && count(newElements!) > 0 {
            switch favoriteLocationRepository.fetchState {
            case .Fetched:
                tableView.beginUpdates()
                
                var currentIndex = favoriteLocationRepository.elementCount - count(newElements!)
                for newElement in newElements! {
                    tableView.insertRowsAtIndexPaths(
                        [ NSIndexPath(forRow: currentIndex, inSection: Section.Collection.rawValue) ],
                        withRowAnimation: UITableViewRowAnimation.Automatic
                    )
                    currentIndex++
                }
                
                if favoriteLocationRepository.atEnd {
                    tableView.deleteRowsAtIndexPaths(
                        [ NSIndexPath(forRow: 0, inSection: Section.Loading.rawValue) ],
                        withRowAnimation: UITableViewRowAnimation.Automatic
                    )
                }
                
                tableView.endUpdates()
                break
            case .NotFetched, .Fetching, .Error:
                break
            }
        } else {
            tableView.reloadData()
        }
    }
    
    // MARK:- Favorite Locations
    
    private func fetchFavoriteLocations(handler: ([ Location ]?, NSError?) -> Void = { $0 }) {
        if favoriteLocationRepository.atEnd {
            return
        }
        
        let isEmptyLocationRepository = favoriteLocationRepository.elementCount == 0
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
                strongSelf.updateUI(animated: !isEmptyLocationRepository, newElements: locations)
                handler(locations, error)
            }
        }
    }
    
    // MARK:- Action Handlers
    
    public func handleButtonTap(sender: UIButton) {
        delegate?.viewController(self, didTapMenuButton: sender)
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
            cell.tag = indexPath.row
            
            let location = favoriteLocationRepository.elements[indexPath.row]
            imageViewLazyLoader.setImage(
                URLString: location.imageUrl,
                imageView: cell.backgroundImageView,
                animated: true
            )
            
            cell.primaryLabel.text = location.title
            cell.secondaryLabel.text = location.subtitle
            
            return cell
        case .Loading:
            let cell = tableView.dequeueReusableCellWithIdentifier(LoadingCell.identifier, forIndexPath: indexPath) as! LoadingCell
            cell.activityIndicatorView.startAnimating()
            fetchFavoriteLocations()
            return cell
        }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section)! {
        case .Collection:
            return Layout.largeCellHeight
        case .Loading:
            return Layout.mediumCellHeight
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
