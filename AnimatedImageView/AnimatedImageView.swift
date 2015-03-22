//
//  AnimatedImageView.swift
//  BDModules
//
//  Created by Patrick Hogan on 1/2/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import SDWebImage
import UIKit

public extension UIImageView {
    
    public func setImage(
        #URLString: String?,
        placeholderImage: UIImage? = nil,
        animated: Bool = false,
        completion: SDWebImageCompletionBlock = { $0 }) {
            if URLString == nil || count(URLString!) == 0 {
                image = placeholderImage
            } else {
                sd_setImageWithURL(NSURL(string: URLString!), placeholderImage: placeholderImage) { [weak self] image, error, cacheType, url in
                    if let strongSelf = self where animated {
                        UIView.transitionWithView(
                            strongSelf,
                            duration: UIView.defaultAnimationDuration(),
                            options: UIViewAnimationOptions.TransitionCrossDissolve,
                            animations: {
                                strongSelf.image = ((image != nil && image!.data.length != 0) ? image : placeholderImage)
                                return
                            }) { [weak self] finished in
                                if let strongSelf = self {
                                    completion(image, error, cacheType, url)
                                }
                        }
                    }
                }
            }
    }
    
}
