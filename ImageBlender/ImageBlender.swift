//
//  ImageBlender.swift
//  Harness
//
//  Created by Patrick Hogan on 3/23/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public class ImageBlender: NSObject {

    private let context = CIContext(options: nil)
    
    public func blend(image: UIImage, withImage overlayImage: UIImage) -> UIImage {
        let inputImage = CIImage(CGImage: image.CGImage)
        let saturationFilter = CIFilter(name: "CIColorControls", withInputParameters: [ "inputSaturation": 0.0 ])        
        saturationFilter.setValue(inputImage, forKey: kCIInputImageKey)
        
        let blendFilter = CIFilter(name: "CIMultiplyBlendMode")
        blendFilter.setValue(saturationFilter.valueForKey(kCIOutputImageKey), forKey: kCIInputImageKey)
        blendFilter.setValue(CIImage(CGImage: overlayImage.CGImage), forKey: kCIInputBackgroundImageKey)
        
        let filteredImage = blendFilter.valueForKey(kCIOutputImageKey) as! CIImage
        let cgImage = context.createCGImage(filteredImage, fromRect: filteredImage.extent())
        
        let blendedImage = UIImage(CGImage: cgImage)!
        
        let finalImage = UIImage(
            CGImage: blendedImage.CGImage,
            scale: UIScreen.mainScreen().scale,
            orientation: blendedImage.imageOrientation
            )!
        
        return finalImage
    }
    
}
