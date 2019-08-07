//
//  EventAnnotationView.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import MapKit
import Kingfisher

//  MARK: Battle Rapper View
internal final class EventAnnotationView: MKMarkerAnnotationView {
    //  MARK: Properties
    internal override var annotation: MKAnnotation? { willSet { newValue.flatMap(configure(with:)) } }
}
//  MARK: Configuration
private extension EventAnnotationView {
    func configure(with annotation: MKAnnotation) {
        guard annotation is EventAnnotation else { fatalError("Unexpected annotation type: \(annotation)") }
        markerTintColor = .purple
        glyphImage = UIImage(named: "MyHel")
        clusteringIdentifier = nil// String(describing: EventAnnotationView.self)
    }
}
