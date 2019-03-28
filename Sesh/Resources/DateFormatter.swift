//
//  DateFormatter.swift
//  Sesh
//
//  Created by Jack Knight on 3/28/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

extension Date {
    
    func formattedString() -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func formattedShortString() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let dateString = formatter.string(from: self)
        return dateString
    }
}

