//
//  EventAnnotation.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import MapKit

final class EventAnnotation: NSObject, MKAnnotation {
    
    enum `Type`: String {
        case event, place
    }
    
    let id: String?
    let color: UIColor
    let type: Type
    let coordinate: CLLocationCoordinate2D
    
    init(color: UIColor, type: Type, coordinate: CLLocationCoordinate2D, id: String) {
        self.id = id
        self.color = color
        self.type = type
        self.coordinate = coordinate
   }
}
