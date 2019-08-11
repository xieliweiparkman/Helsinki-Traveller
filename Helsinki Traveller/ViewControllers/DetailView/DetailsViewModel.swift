//
//  DetailsViewModel.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 09/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum DetailsType {
    case Event
    case Place
    case Activity
}

protocol DetailsViewModelProtocol {
    
    //Input
    var id: String { get }
    var detailsType: DetailsType { get }
    var provider: MyAPIServices? { get }
    
    //Output
    var event: BehaviorRelay<Event?> { get }
    var place: BehaviorRelay<Place?> { get }
    var activity: BehaviorRelay<Activity?> { get }
    var images: BehaviorRelay<[Image]?> { get }
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    //Input
    var id: String
    var detailsType: DetailsType
    var provider: MyAPIServices?
    //Output
    let event = BehaviorRelay<Event?>(value: nil)
    let place = BehaviorRelay<Place?>(value: nil)
    let activity = BehaviorRelay<Activity?>(value: nil)
    let images = BehaviorRelay<[Image]?>(value: nil)
    fileprivate let bag = DisposeBag()
    
    init(id: String,
         detailsType: DetailsType,
         event: Event?,
         place: Place?,
         activity: Activity?,
         provider: MyAPIServices?) {
        self.id = id
        self.detailsType = detailsType
        self.provider = provider
        self.event.accept(event)
        self.place.accept(place)
        self.activity.accept(activity)
    }
    
}
