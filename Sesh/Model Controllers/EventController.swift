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
    var event: Event?
    
    // root url https://app.ticketmaster.com/discovery/v2/
    
    // https://app.ticketmaster.com/discovery/v2/events.json?apikey=e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH&keyword=&startDateTime=2019-04-12T01:01:01Z&sort=date,asc&city=los%20angeles
    
    static let baseURL = URL(string: "https://app.ticketmaster.com/discovery/v2/")
    private static let apiKey = "e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH"
    
    
    //Fetch array of events by Category
    func fetchEventsBy(segmentName: String, with city: String, startTime: String, completion: @escaping (Result<[Event], NSError>) -> Void) {
        guard var url = EventController.baseURL else {
            let error = NSError()
            completion(.failure(error))
            return
        }
        
        url.appendPathComponent("events")
         url.appendPathExtension("json")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let apiQueryItem = URLQueryItem(name: "apikey", value: "e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH")
        let segmentNameQuery = URLQueryItem(name: "segmentName", value: segmentName)
        let startDateTimeQuery = URLQueryItem(name: "startDateTime", value: startTime)
        let sortQueryItem = URLQueryItem(name: "sort", value: "date,desc")
        let cityQueryItem = URLQueryItem(name: "city",value: city)
        
        components?.queryItems = [apiQueryItem, segmentNameQuery, sortQueryItem, startDateTimeQuery, cityQueryItem]
        
        guard let finalURL = components?.url else { let error = NSError()
        
            completion(.failure(error))
            return
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("🔥There was an error with dataTask : \(error.localizedDescription)🔥")
                completion(.failure(error as NSError))
                return
            }
            
            guard let data = data else { let error = NSError()
                completion(.failure(error)); return}
            
            let decoder = JSONDecoder()
            
            do {
                let eventSearch = try decoder.decode(JSONResults.self, from: data)
                completion(.success(eventSearch.embedded?.events ?? []))
                
            } catch let error {
                print("Error decoding the data from api: \(error.localizedDescription)")
                completion(.failure(error as NSError))
                return
            }
        }
        
        dataTask.resume()
    }
    
    // Fetch events by a searchTerm keyword
    func fetchEventResults(with searchTerm: String, with city: String, startTime: String, completion: @escaping (Result<[Event], NSError>) -> Void) {
        guard var url = EventController.baseURL else {
            let error = NSError()
            completion(.failure(error))
            return
        }
        
        url.appendPathComponent("events")
        url.appendPathExtension("json")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let apiQueryItem = URLQueryItem(name: "apikey", value: "e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH")
        let keywordQueryItem = URLQueryItem(name: "keyword", value: searchTerm)
        let startDateTimeQuery = URLQueryItem(name: "startDateTime", value: startTime)
        let sortQueryItem = URLQueryItem(name: "sort", value: "date,asc")
        let cityQueryItem = URLQueryItem(name: "city", value: city)
        
        components?.queryItems = [apiQueryItem, keywordQueryItem, sortQueryItem, startDateTimeQuery, cityQueryItem]
       
        
        guard let finalURL = components?.url else { let error = NSError()
            completion(.failure(error))
            return
        }
        
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("🔥There was an error with dataTask : \(error.localizedDescription)🔥")
                completion(.failure(error as NSError))
                return
            }
            
            guard let data = data else { let error = NSError()
                completion(.failure(error)); return}
            
            let decoder = JSONDecoder()
            
            do {
                let eventSearch = try decoder.decode(JSONResults.self, from: data)
                completion(.success(eventSearch.embedded?.events ?? []))
                
            } catch let error {
                print("Error decoding the data from api: \(error.localizedDescription)")
                completion(.failure(error as NSError))
                return
            }
        }
        
        dataTask.resume()
    }
    
     func fetchEventPicture(_ imageURL: String, completion: @escaping (Result<UIImage, NSError>) -> Void) {
        //Setting up the url to get the image
       
        guard let urlForImage = URL(string: imageURL) else { let error = NSError()
            completion(.failure(error as NSError)); return}
        
        //Start the data taks to fetch the  image
        let dataTask = URLSession.shared.dataTask(with: urlForImage) { (data, response, error) in
            if let error = error {
                print(" There was an error in \(#function) ; \(error) ; \(error.localizedDescription)")
                completion(.failure(error as NSError))
                return
            }
            // check to see if you have data
            guard let imageData = data else { let error = NSError()
                completion(.failure(error as NSError))
                return
            }
            // change the data into a UIImage to be displayed
            guard let image = UIImage(data: imageData) else {
                let error = NSError()
                completion(.failure(error))
                return
                
            }
            completion(.success(image))
        }
        dataTask.resume()
    }
}
