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
        case locationName = "venues"
        case seatMap = "seatmap"
        case cityName = "city"
    }
    
    let name: String
    let date: Dates
    let time: Dates
    let locationName: Venue
    let seatMap: String
    let cityName: CityLocation
    
}

struct Dates: Codable {
    
    let date: Date
    let time: Date
}

struct Venue: Codable {
    let name: String?
}

struct CityLocation: Codable {
    let cityName: String
}
