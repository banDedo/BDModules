//
//  MockImageViewLazyLoader.swift
//  Harness
//
//  Created by Patrick Hogan on 3/22/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import SDWebImage
import UIKit

public class MockImageViewLazyLoader: ImageViewLazyLoader {

    // MARK:- Injectable

    private var currentImageIndex = Int(0)
    public lazy var images = [ UIImage ]()
    
    // MARK:- Set Image
    
    public override func setImage(
        #URLString: String?,
        imageView: UIImageView,
        placeholderImage: UIImage?,
        animated: Bool,
        completion: SDWebImageCompletionBlock) {
            
            var placeholderImage: UIImage?
            
            // If a child of a tableview cell, rely on tag for image index
            var view: UIView? = imageView
            while view != nil {
                view = view?.superview
                if view != nil && view!.isKindOfClass(UITableViewCell.self) {
                    placeholderImage = images[view!.tag]
                    break
                }
            }
            
            // Otherwise move in order and reset when out of bound
            if placeholderImage == nil {
                placeholderImage = images[currentImageIndex]
                currentImageIndex = ++currentImageIndex % images.count
            }
            
            super.setImage(
                URLString: URLString,
                imageView: imageView,
                placeholderImage: placeholderImage,
                animated: animated,
                completion: completion
            )
    }
    
}
