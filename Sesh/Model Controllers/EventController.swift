//
//  EventControlller.swift
//  Sesh
//
//  Created by Jack Knight on 3/18/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class EventController {
    
    // Shared instance
    static let shared = EventController()
    
    // root url https://app.ticketmaster.com/discovery/v2/
    
    static let baseURL = URL(string: "https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&apikey=e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH")
    private static let apiKey = "e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH"
    
    //Fetch data from api
     static func fetchEventResults(with searchTerm: String, completion: @escaping ([Event]?) -> Void) {
        guard let url = baseURL else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("🔥There was an error with dataTask : \(error.localizedDescription)🔥")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil); return}
            
            let decoder = JSONDecoder()
           
            do {
                let eventSearch = try decoder.decode(EventSearch.self, from: data)
                let events = eventSearch.eventResults
                completion(events)
            } catch let error {
                print("Error decoding the data from api: \(error.localizedDescription)")
                completion(nil)
                return
            }
        }
        dataTask.resume()
    }
}


