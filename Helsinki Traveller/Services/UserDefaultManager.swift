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

    var key: String {
        switch self {
        case .favouriteEvents: return "favouriteEvents"
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
    
    func addOneFavouriteEvent(event: Event) {
        let title = event.name.en ?? event.name.fi ?? ""
        let des = (event.description.body ?? "").convertHtml().string
        let url = event.description.images?.count == 0 ? "" : event.description.images?[0].url ?? ""
        let dict = ["id": event.id,
                    "title": title,
                    "des": des,
                    "url": url
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
        return events
    }
}
