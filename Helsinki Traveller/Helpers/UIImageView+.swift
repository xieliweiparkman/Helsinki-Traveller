//
//  UIImageView+.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image = UIImage(named: "MyHel")
            return
        }
        let resource = ImageResource(downloadURL: url)
        self.kf.setImage(with: resource,
                         placeholder: UIImage(named: "MyHel"),
                         options: [.processor(DownsamplingImageProcessor(size: CGSize(width: 450, height: 450))),
                                   .cacheOriginalImage])
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
