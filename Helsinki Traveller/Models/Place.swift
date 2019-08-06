//
//  Place.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation

class Place: Codable {
    var id: String
    var name: Name
    var sourceType: SourceType
    var infoUrl: String?
    var modifiedAt: String
    var location: Location
    var description: Description
    var tags: [Tag]
    var openingHours: OpeningHours
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sourceType = "source_type"
        case infoUrl = "info_url"
        case modifiedAt = "modified_at"
        case location
        case description
        case tags
        case openingHours = "opening_hours"
    }
}

struct PlaceData: Codable {
    var meta: Meta
    var places: [Place]
    enum CodingKeys: String, CodingKey {
        case meta
        case places = "data"
    }
}

struct OpeningHours: Codable {
    let hours: [HelHour]?
    let openinghoursException: String?
    
    enum CodingKeys: String, CodingKey {
        case hours
        case openinghoursException = "openinghours_exception"
    }
}

struct HelHour: Codable {
    let weekdayId: Int
    let opens: String?
    let closes: String?
    let open24h: Bool
    
    enum CodingKeys: String, CodingKey {
        case weekdayId = "weekday_id"
        case opens, closes, open24h
    }
}
