//
//  MainViewModel.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol {
    //Input
    var provider: MyAPIServices? { get }
    
    var events: BehaviorRelay<[Event]> { get }
    var cleanEvents: BehaviorRelay<[Event]> { get }

    var activities: BehaviorRelay<[Activity]> { get }
    var places: BehaviorRelay<[Place]> { get }
    var favouriateEvents: BehaviorRelay<[[String: Any]]> { get }
    //Output
    var transition: PublishSubject<MainTransition> { get }
    var didTapFavouriteButton: PublishSubject<Event> { get }
    var didTapOnRemoveFavouriteButton: PublishSubject<String> { get }
    
}

class MainViewModel: MainViewModelProtocol {
    
    //Input
    var provider: MyAPIServices?
    var events: BehaviorRelay<[Event]>
    let cleanEvents = BehaviorRelay<[Event]>(value: [])

    var activities: BehaviorRelay<[Activity]>
    var places: BehaviorRelay<[Place]>
    let favouriateEvents = BehaviorRelay<[[String: Any]]>(value: [])
    //Output
    let transition = PublishSubject<MainTransition>()
    let didTapFavouriteButton = PublishSubject<Event>()
    let didTapOnRemoveFavouriteButton = PublishSubject<String>()
    
    fileprivate let bag = DisposeBag()
    
    init(provider: MyAPIServices?,
         eventData: EventData,
         activities: [Activity],
         placeData: PlaceData) {
        self.provider = provider
        self.events = BehaviorRelay<[Event]>(value: eventData.events)
        self.activities = BehaviorRelay<[Activity]>(value: activities)
        self.places = BehaviorRelay<[Place]>(value: placeData.places)
        didTapFavouriteButton.subscribe(onNext: { [weak self] event in
            guard let strongSelf = self else { return }
            strongSelf.tapOnFavouriteButton(event: event)
        }).disposed(by: bag)
        
        didTapOnRemoveFavouriteButton.subscribe(onNext: { [weak self] eventId in
            guard let strongSelf = self else { return }
            strongSelf.removeOneFavouriteEvent(eventId: eventId)
        }).disposed(by: bag)
        
        self.events.subscribe(onNext: { [weak self] events in
            guard let strongSelf = self else { return }
            strongSelf.removeDuplicatedEvents(events: events)
        }).disposed(by: bag)
    }
    
    func tapOnFavouriteButton(event: Event) {
        if event.isFavouriteEvent() {
            removeOneFavouriteEvent(eventId: event.id)
        } else {
            UserDefaultsManager.shared.addOneFavouriteEvent(event: event)
        }
    }
    
    func removeOneFavouriteEvent(eventId: String) {
        UserDefaultsManager.shared.removeOneFavouriteEvent(eventId: eventId)

    }
    
    func removeDuplicatedEvents(events: [Event]) {
        //There are duplicated events with same number but diffrent time, only show the cloest one
        var newEvents = [Event]()
        var eventsDic = [String: Event]()
        for event in events {
            let name = event.name.fi ?? event.name.en ?? event.name.sv ?? event.name.zh ?? "unknown"
            if eventsDic[name] == nil {
                eventsDic[name] = event
                newEvents.append(event)
            }
        }
        cleanEvents.accept(newEvents)
    }
}
