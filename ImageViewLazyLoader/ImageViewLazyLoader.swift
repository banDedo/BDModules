//
//  ImageViewLazyLoader.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/2/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import SDWebImage
import UIKit

public class ImageViewLazyLoader {
    
    public func setImage(
        #URLString: String?,
        imageView: UIImageView,
        placeholderImage: UIImage? = nil,
        animated: Bool = false,
        completion: SDWebImageCompletionBlock = { $0 }) {
            if URLString == nil || count(URLString!) == 0 {
                imageView.image = placeholderImage
            } else {
                imageView.sd_setImageWithURL(NSURL(string: URLString!), placeholderImage: placeholderImage) { [weak imageView] image, error, cacheType, url in
                    if let strongImageView = imageView where animated {
                        UIView.transitionWithView(
                            strongImageView,
                            duration: UIView.defaultAnimationDuration(),
                            options: UIViewAnimationOptions.TransitionCrossDissolve,
                            animations: {
                                strongImageView.image = ((image != nil && image!.data.length != 0) ? image : placeholderImage)
                                return
                            }) { [weak imageView] finished in
                                if let strongImageView = imageView {
                                    completion(image, error, cacheType, url)
                                }
                        }
                    }
                }
            }
    }
    
}
