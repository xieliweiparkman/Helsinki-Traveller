//
//  Event.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation
import SwiftDate

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
    
    func startDate() -> Date {
        guard let startTime = eventDates.startingDay else { return Date()}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: startTime) ?? Date()
    }
    
    func endDate() -> Date? {
        guard let stopTime = eventDates.endingDay else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: stopTime)
    }
    
    func tagsString() -> String {
        if tags.count == 0 { return "" }
        var string = ""
        for tag in tags {
            string += "#\(tag.name), "
        }
        string.removeLast(2)
        return string
    }
    
    func startTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd.M.yyyy hh:mm"
        return dateFormatter.string(from: startDate())
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
