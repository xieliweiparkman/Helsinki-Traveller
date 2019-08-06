//
//  String+.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data,
                                          options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    func cleanUrl() -> String {
        let removedLeft = self.replacingOccurrences(of: "{", with: "")
        return removedLeft.replacingOccurrences(of: "}", with: "")
    }
}
