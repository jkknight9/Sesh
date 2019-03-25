//
//  Event.swift
//  Sesh
//
//  Created by Jack Knight on 3/18/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import Foundation

struct EventSearch: Codable {
    
    let eventResults: [Event]
    
    enum CodingKeys: String, CodingKey {
        case eventResults = "events"
    }
}

struct Event: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case date = "localDate"
        case time = "localTime"
        case info = "info"
        case locationName = "venues"
        case seatMap = "seatmap"
        case cityName = "city"
        case image = "images"
    }
    
    let name: String
    let date: Dates
    let time: Dates
    let info: String
    let locationName: Venue
    let seatMap: String
    let cityName: CityLocation
    let image: Images
    
}

struct Images: Codable {
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
    let imageURL: String?
}

struct Dates: Codable {
    
    enum CodingKeys: String, CodingKey {
        case date = "localDate"
        case time  = "localTime"
    }
    
    let date: Date
    let time: Date
}

struct Venue: Codable {
    let name: String?
}

struct CityLocation: Codable {
    let cityName: String
}
