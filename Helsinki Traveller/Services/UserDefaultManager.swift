//
//  UserDefaultManager.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation

private enum UserDefaultsKey {
    case favouriteEvents
    case savedEvents
    var key: String {
        switch self {
            
        case .favouriteEvents: return "favouriteEvents"
        case .savedEvents: return "savedEvents"
            
        }
    }
    
}
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    var favouriteEvents: [String: Any] {
        get {
            return (UserDefaults.standard.object(forKey: UserDefaultsKey.favouriteEvents.key) as? [String : Any]) ?? [:]
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.favouriteEvents.key)
        }
    }
    
    var savedEvents: [String: String] {
        get {
            return (UserDefaults.standard.object(forKey: UserDefaultsKey.savedEvents.key) as? [String : String]) ?? [:]
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.savedEvents.key)
        }
    }
    
    func addOneFavouriteEvent(event: Event) {
        let title = event.name.en ?? event.name.fi ?? ""
        let des = (event.description.body ?? "").convertHtml().string
        let url = event.description.images?.count == 0 ? "" : event.description.images?[0].url ?? ""
        let modifiedAt = event.modifiedAt
        let dict = ["id": event.id,
                    "title": title,
                    "des": des,
                    "url": url,
                    "modifiedAt": modifiedAt
                    ]
        favouriteEvents[event.id] = dict
    }
    
    func removeOneFavouriteEvent(eventId: String) {
        favouriteEvents[eventId] = nil
    }
    
    func favouriteEventsArray() -> [[String: Any]] {
        var events = [[String: Any]]()
        for event in favouriteEvents {
            events.append(event.value as! [String : Any])
        }
        
        let sortedEvents = events.sorted { ($0["modifiedAt"] as! String) < ($1["modifiedAt"] as! String) }

        return sortedEvents
    }
}
