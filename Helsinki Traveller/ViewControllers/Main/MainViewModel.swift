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
import EventKit

protocol MainViewModelProtocol {
    //Input
    var provider: MyAPIServices? { get }
    
    var events: BehaviorRelay<[Event]> { get }
    var cleanEvents: BehaviorRelay<[Event]> { get }

    var activities: BehaviorRelay<[Activity]> { get }
    var places: BehaviorRelay<[Place]> { get }
    var favouriateEvents: BehaviorRelay<[[String: Any]]> { get }
    //Output
    var storedOffsets: [Int: CGFloat] { get set }
    var transition: PublishSubject<MainTransition> { get }
    var didTapFavouriteButton: PublishSubject<Event> { get }
    var didTapOnRemoveFavouriteButton: PublishSubject<String> { get }
    
    var didAddedEvent: PublishSubject<Void> { get }
    var didRemovedEvent: PublishSubject<Void> { get }

    var error: PublishSubject<AppError> { get }
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
    var storedOffsets = [Int: CGFloat]()
    let transition = PublishSubject<MainTransition>()
    let didTapFavouriteButton = PublishSubject<Event>()
    let didTapOnRemoveFavouriteButton = PublishSubject<String>()
    
    let didAddedEvent = PublishSubject<Void>()
    let didRemovedEvent = PublishSubject<Void>()
    
    let error = PublishSubject<AppError>()

    
    fileprivate let bag = DisposeBag()
    
    init(provider: MyAPIServices?,
         eventData: EventData,
         activities: [Activity]?,
         placeData: PlaceData) {
        self.provider = provider
        self.events = BehaviorRelay<[Event]>(value: eventData.events)
        self.activities = BehaviorRelay<[Activity]>(value: activities ?? [])
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
            addEventToCalendar(event: event)
            UserDefaultsManager.shared.addOneFavouriteEvent(event: event)
        }
    }
    
    func removeOneFavouriteEvent(eventId: String) {
        UserDefaultsManager.shared.removeOneFavouriteEvent(eventId: eventId)
        removeEventFromCalendar(eventId: eventId)
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
        let sortedEvents = newEvents.sorted { $0.modifiedAt < $1.modifiedAt}
        cleanEvents.accept(sortedEvents)
    }
    
    func addEventToCalendar(event: Event) {
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { granted, error in
            if (granted) && (error == nil) {
                
                let calendarEvent: EKEvent = EKEvent(eventStore: eventStore)
                calendarEvent.title = event.name.fi
                calendarEvent.startDate = event.startDate()
                
                if let endDate = event.endDate() {
                    calendarEvent.endDate = endDate
                } else {
                    calendarEvent.endDate = event.startDate().addingTimeInterval(3600)
                }
                calendarEvent.notes = event.description.body?.convertHtml().string ?? ""
                calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(calendarEvent, span: .thisEvent)
                    UserDefaultsManager.shared.savedEvents[event.id] = calendarEvent.eventIdentifier
                    print("Did add event at \(calendarEvent.startDate.toString())")
                    self.didAddedEvent.onNext(())
                } catch {
                    self.error.onNext(.addEventFailed)
                }
            } else {
                self.error.onNext(.noCalendarAccess)
            }
        })
    }
    
    func removeEventFromCalendar(eventId: String) {
        let store = EKEventStore()
        store.requestAccess(to: .event, completion: { granted, error in
            if !granted {
                self.error.onNext(.noCalendarAccess)
                return
            }
            guard let eventKitId = UserDefaultsManager.shared.savedEvents[eventId] else { return }

            let eventToRemove = store.event(withIdentifier: eventKitId)
            if eventToRemove != nil {
                do {
                    try store.remove(eventToRemove!, span: .thisEvent, commit: true)
                    UserDefaultsManager.shared.savedEvents[eventId] = nil
                    print("Did remove event at \(eventToRemove?.startDate.toString())")
                    self.didRemovedEvent.onNext(())
                } catch {
                    self.error.onNext(.removeEventFailed)
                }
            }
        })
    }
}
