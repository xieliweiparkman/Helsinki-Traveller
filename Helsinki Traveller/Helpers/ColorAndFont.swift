//
//  ColorAndFont.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func appRedColor() -> UIColor {
        return UIColor(hex: 0xE30310)// (red: 227/255.0, green: 3/255.0, blue: 16/255.0, alpha: 1)
    }
    
    class func appRedColorWithAlpha(alpha: CGFloat) -> UIColor {
        return UIColor(red: 227/255.0, green: 3/255.0, blue: 16/255.0, alpha: alpha)
    }
    class func appGreenColor() -> UIColor {
        return UIColor(red: 44.0/255.0, green: 150.0/255.0, blue: 55/255.0, alpha: 1)
    }
    
    class func appBlackColor() -> UIColor {
        return UIColor(red: 31.0/255.0, green: 25.0/255.0, blue: 22/255.0, alpha: 1)
    }
    
    class func appWhiteBackgroundColor() -> UIColor {
        return UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
    }
    
    class func appOrangeColor() -> UIColor {
        return UIColor(red: 236/255.0, green: 191/255.0, blue: 97/255.0, alpha: 1)
    }
    
    class func appLightBlackColor() -> UIColor {
        return UIColor(red: 48/255.0, green:46.0/255.0, blue: 46.0/255.0, alpha: 1)
    }
    
    class func appGreyBackgroundColor() -> UIColor {
        return UIColor(red: 238/255.0, green:241.0/255.0, blue: 264.0/255.0, alpha: 1)
    }
    
    class func appLabelGreyColor() -> UIColor {
        return UIColor(red: 68/255.0, green:66.0/255.0, blue: 66.0/255.0, alpha: 1)
    }
    
    class func appBlueWithAlpha(alpha: CGFloat) -> UIColor {
        return UIColor(red: 41/255.0, green:196.0/255.0, blue: 246.0/255.0, alpha: alpha)
    }
}
extension UIFont {
    static func appRegularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: size)!
    }
    
    static func appMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Medium", size: size)!
    }
    
    static func appBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Bold", size: size)!
    }
    static func appSemiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-SemiBold", size: size)!
    }
    
    static func appLightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Light", size: size)!
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
