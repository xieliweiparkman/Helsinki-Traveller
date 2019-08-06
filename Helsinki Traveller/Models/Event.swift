//
//  Event.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation

class Event: Codable {
    var id: String
    var name: Name
    var sourceType: SourceType
    var infoUrl: String?
    var modifiedAt: String
    var location: Location
    var description: Description
    var tags: [Tag]
    var eventDates: EventDates
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sourceType = "source_type"
        case infoUrl = "info_url"
        case modifiedAt = "modified_at"
        case location
        case description
        case tags
        case eventDates = "event_dates"
    }
    
    func isFavouriteEvent() -> Bool {
        return UserDefaultsManager.shared.favouriteEvents[id] != nil
    }
}

struct EventData: Codable {
    var meta: Meta
    var events: [Event]
    enum CodingKeys: String, CodingKey {
        case meta
        case events = "data"
    }
}

struct EventDates: Codable {
    let startingDay: String?
    let endingDay: String?
    let additionalDescription: String?

    enum CodingKeys: String, CodingKey {
        case startingDay = "starting_day"
        case endingDay = "ending_day"
        case additionalDescription = "additional_description"
    }
}

struct Meta: Codable {
    var count: String
    var next: String?
}
