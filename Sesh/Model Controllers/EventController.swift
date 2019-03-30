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
    
    static let baseURL = URL(string: "https://app.ticketmaster.com/discovery/v2/")
    private static let apiKey = "e3ET0ctEGswTpGJ9E31cWfGBvZAiGReH"
    
    
    //Fetch data from api
    func fetchEventResults(with searchTerm: String, with city: String, completion: @escaping (Result<[Event], NSError>) -> Void) {
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
        let sortQueryItem = URLQueryItem(name: "sort", value: "date,asc")
        let cityQueryItem = URLQueryItem(name: "city", value: city)
        
        components?.queryItems = [apiQueryItem, keywordQueryItem, sortQueryItem, cityQueryItem]
       
        
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
    
    func dateFormatter(_ dateString: String) {
        var convertedDate: String = ""
        var convertTime: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH-mm-ss"
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "h:mm a"
        
        guard let dateTime = event?.dates?.start?.dateTime else {return}
            let dateComponents = dateTime.components(separatedBy: "T")
        
        let splitDate = dateComponents[0]
        let splitTime = dateComponents[1]
        
        if let date = dateFormatter.date(from: splitDate) {
            convertedDate = newDateFormatter.string(from: date)
        }
        
        if let time = timeFormatter.date(from: splitTime) {
            convertTime = newTimeFormatter.string(from: time)
        }
        

    
    
    
    
    
}

}
