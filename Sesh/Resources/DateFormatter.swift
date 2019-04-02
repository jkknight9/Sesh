//
//  DateFormatter.swift
//  Sesh
//
//  Created by Jack Knight on 4/2/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class DateFomatter {
    
    var event: Event?
    
    func DateFromatter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let exampleDate = event?.dates?.start?.dateTime else {return}
        guard let date = dateFormatter.date(from: exampleDate) else {return}
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let formattedDate  = dateFormatter.string(from: date)
        event?.dates?.start?.dateTime = formattedDate
        
    }
}
