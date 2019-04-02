//
//  Event.swift
//  Sesh
//
//  Created by Jack Knight on 3/18/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit


struct JSONResults: Codable {
   
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
    var embedded: Events?
}

struct Events: Codable {
    
    var events: [Event]?
    
    enum CodingKeys: String, CodingKey {
        case events = "events"
    }
}

struct Event: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case info = "info"
        case embedded = "_embedded"
        case classifications
        case seatMap = "seatmap"
        case image = "images"
        case dates
    }
    
    var name: String?
    var id: String?
    var info: String?
    var seatMap: SeatMap?
    var embedded: Embedded?
    var classifications: [Classification]?
    var image: [Images]?
    var dates: Dates? 
    
}

struct Images: Codable {
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "url"
    }
    var imageURL: String?
    
}

struct EventDate: Codable {
    enum CodingKeys: String, CodingKey {
        case dateTime = "dateTime"
        
    }
    var dateTime: String?
}

struct Dates: Codable {
    enum CodingKeys: String, CodingKey {
        case start = "start"
    }
    var start: EventDate?
}

struct Embedded: Codable {
    
    enum CodingKeys: String, CodingKey {
        case venues = "venues"
        
    }
    var venues: [Venue]?
}

struct SeatMap: Codable {
    enum CodingKeys: String, CodingKey {
        case staticURL = "staticUrl"
    }
    var staticURL: String?
}


struct Venue: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case city
    }
    var name: String?
    var id: String?
    var city: City?
}

struct Classification: Codable {
    enum CodingKeys: String, CodingKey {
        case segment
    }
    var segment: Segment?
}

struct Segment: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    var name: String?
    var id: String?
}

struct City: Codable {
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
    }
    let cityName: String
}
