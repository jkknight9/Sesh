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
        FormatDate.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let exampleDate = isoString else {return ""}
        guard let date = FormatDate.dateFormatter.date(from: exampleDate) else {return ""}
        FormatDate.dateFormatter.dateFormat = "MMM d, h:mm a"
        let formattedDate  = FormatDate.dateFormatter.string(from: date)
        return formattedDate
    }
    
    static func getCurrentDate() -> String {
        FormatDate.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return FormatDate.dateFormatter.string(from: Date()) + "Z"
    }
}

