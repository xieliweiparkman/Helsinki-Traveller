//
//  UIViewController+.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import DeviceKit

extension UIViewController: NVActivityIndicatorViewable {
    public func startAnimating() {
        if Device().isSimulator {
            return
        }
        startAnimating(nil, message: nil, messageFont: nil, type: NVActivityIndicatorType.ballRotate, color: UIColor.appRedColor(), padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: UIColor.appBlueWithAlpha(alpha: 0.4), textColor: nil, fadeInAnimation: nil)
    }
    
    public func stopLoadingAnimation() {
        stopAnimating()
    }
}
