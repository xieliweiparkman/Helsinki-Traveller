//
//  Activity.swift
//  Helsinki Traveller
//
//  Created by Xie Liwei on 06/08/2019.
//  Copyright © 2019 GreenCross. All rights reserved.
//

import Foundation

class Activity: Codable {
    var id: String
    var name: Name
    var sourceType: SourceType
    var infoUrl: String?
    var modifiedAt: String
    var location: Location
    var description: Description
    var tags: [Tag]
    var whereWhenDuration: WhereWhenDuration
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sourceType = "source_type"
        case infoUrl = "info_url"
        case modifiedAt = "modified_at"
        case location
        case description
        case tags
        case whereWhenDuration = "where_when_duration"
    }

}

struct Name: Codable {
    let fi: String?
    let en: String?
    let sv: String?
    let zh: String?
    enum CodingKeys: String, CodingKey {
        case fi, en, sv, zh
    }
}

struct SourceType: Codable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct Location: Codable {
    let lat: Double?
    let lon: Double?
    let address: Address
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, address
    }
}

struct Address: Codable {
    let streetAddress: String?
    let postalCode: String?
    let locality: String?
    
    enum CodingKeys: String, CodingKey {
        case streetAddress = "street_address"
        case postalCode = "postal_code"
        case locality
    }
}

struct Description: Codable {
    let intro: String?
    let body: String?
    let images: [Image]?
    
    enum CodingKeys: String, CodingKey {
        case intro, body, images
    }
}

struct Image: Codable {
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}

struct Tag: Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct WhereWhenDuration: Codable {
    let whereAndWhen: String
    let duration: String
    
    enum CodingKeys: String, CodingKey {
        case whereAndWhen = "where_and_when"
        case duration
    }
}
