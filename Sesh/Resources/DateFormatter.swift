//
//  DateFormatter.swift
//  Sesh
//
//  Created by Jack Knight on 4/2/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class FormatDate {
    
    
    static let dateFormatter = DateFormatter()
    
    static func convert(isoString: String?) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let exampleDate = isoString else {return ""}
        guard let date = dateFormatter.date(from: exampleDate) else {return ""}
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let formattedDate  = dateFormatter.string(from: date)
        return formattedDate
    }
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: Date()) + "Z"
    }
}

