//
//  FavoriteLocationURLProtocol.swift
//  BDModules
//
//  Created by Patrick Hogan on 2/26/15.
//  Copyright (c) 2015 bandedo. All rights reserved.
//

import UIKit

public class FavoriteLocationURLProtocol: StubURLProtocol {

    public static var counter = 0
    private static let delay = NSTimeInterval(1.0)

    public override var resourceName: String {
        if self.dynamicType.counter++ == 0 {
            return "favorite_locations_first_page_stub"
        } else {
            return "favorite_locations_second_page_stub"
        }
    }
    
    public override func startLoading() {
        let delay = self.dynamicType.delay * Double(NSEC_PER_SEC) * Double(self.dynamicType.counter)
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay)),
            dispatch_get_main_queue()) {
                super.startLoading()
        }
    }
    
}
