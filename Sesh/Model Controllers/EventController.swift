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
    
    // full url https://app.ticketmaster.com/discovery/v2/events.json?apikey=e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH&size=1
    
    //          https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&apikey=e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH
    
    static let baseURL = URL(string: "https://app.ticketmaster.com/discovery/v2/")
    private static let apiKey = "e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH"
    
    //Fetch data from api
     func fetchEventResults(with searchTerm: String, completion: @escaping (Result<[Event], NSError>) -> Void) {
        guard let url = EventController.baseURL else {
            let error = NSError()
            completion(.failure(error))
            return
        }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
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
                guard let events = eventSearch.embedded?.events else { return }
                completion(.success(events))
            } catch let error {
                print("Error decoding the data from api: \(error.localizedDescription)")
                completion(.failure(error as NSError))
                return
            }
        }
        
        dataTask.resume()
    }
    
    static func fetchEventPicture(_ image: Images, completion: @escaping (Result<UIImage, NSError>) -> Void) {
        //Setting up the url to get the image
        var imageBaseUrl = URL(string: "https://app.ticketmaster.com/discovery/v2/events/{id}")

        guard let urlForImage = image.imageURL else { let error = NSError()
            completion(.failure(error as NSError)); return}

        imageBaseUrl?.appendPathComponent(urlForImage)

        guard let finalImageURL = imageBaseUrl else { return}

        //Start the data taks to fetch the  image
        let dataTask = URLSession.shared.dataTask(with: finalImageURL) { (data, response, error) in
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
            guard let image = UIImage(data: imageData) else { return }
            completion(.success(image as UIImage))
        }
        dataTask.resume()
    }
}


