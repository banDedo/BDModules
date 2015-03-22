//
//  BlurView.swift
//  BDModules
//
//  Created by Patrick Hogan on 11/22/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

import UIKit

public class BlurView: UIView {
    
    private var style: UIBlurEffectStyle
    
    private(set) public lazy var blurEffect: UIBlurEffect = {
        return UIBlurEffect(style: self.style)
        }()

    private(set) public lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: self.blurEffect)
        return blurView
        }()

    private(set) public lazy var vibrancyView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: self.blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        return vibrancyView
        }()

    init(style: UIBlurEffectStyle) {
        self.style = style
        super.init(frame: CGRectZero)
        
        blurView.contentView.addSubview(vibrancyView)
        addSubview(blurView)
        
        vibrancyView.snp_makeConstraints{ make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }

        blurView.snp_makeConstraints{ make in
            make.edges.equalTo(UIEdgeInsetsZero)
        }
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
