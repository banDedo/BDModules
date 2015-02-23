//
//  MultipartFile.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/18/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

@objc public protocol MultipartFile {
   
    var data: NSData { get }
    var name: String { get }
    var fileName: String { get }
    var mimeType: String { get }
    
}

extension UIImage: MultipartFile {
    
    public var data: NSData {
        return UIImagePNGRepresentation(self)
    }
    
    public var name: String {
        return "image"
    }

    public var fileName: String {
        return "image.png"
    }
  
    public var mimeType: String {
        return "image/png"
    }
    
}