//
//  MapViewModel.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

protocol MapViewModelProtocol {
    
    //Input
    var mainViewModel: MainViewModelProtocol { get }
    var isEvent: Bool { get }
    
    //Output
    var annotations: BehaviorRelay<[EventAnnotation]> { get }
}

class MapViewModel: MapViewModelProtocol {
    
    var mainViewModel: MainViewModelProtocol
    var isEvent: Bool
    
    let annotations = BehaviorRelay<[EventAnnotation]>(value: [])
    let shouldCluster = BehaviorRelay<Bool>(value: true)
    
    fileprivate let bag = DisposeBag()
    
    init(mainViewModel: MainViewModel, isEvent: Bool) {
        self.mainViewModel = mainViewModel
        self.isEvent = isEvent
        
       generateAnnotations()
    }
    
    func generateAnnotations() {
        var annotations = [EventAnnotation]()

        if isEvent {
            for event in mainViewModel.cleanEvents.value {
                if event.location.lat != nil {
                    let annotation = EventAnnotation(color: .purple,
                                                     type: .event,
                                                     coordinate: CLLocationCoordinate2D(latitude: event.location.lat!, longitude: event.location.lon!),
                                                     id: event.id)
                    annotations.append(annotation)
                }
            }
        } else {
            for place in mainViewModel.places.value {
                if place.location.lat != nil {
                    let annotation = EventAnnotation(color: .purple,
                                                     type: .place,
                                                     coordinate: CLLocationCoordinate2D(latitude: place.location.lat!, longitude: place.location.lon!),
                                                     id: place.id)
                    annotations.append(annotation)
                }
            }
        }
        self.annotations.accept(annotations)
    }
}
