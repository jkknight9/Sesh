//
//  EventTableViewCell.swift
//  Sesh
//
//  Created by Jack Knight on 3/18/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var eventDate: EventDate? {
        didSet{
            updateViews()
        }
    }
    
    var event: Event?{
        didSet {
            updateViews()
        }
    }
        func updateViews() {
        
        guard let event = event else { return}
            DispatchQueue.main.async {
                self.titleLabel.text = event.name
                self.dateLabel.text = self.eventDate?.dateTime
//                self.locationLabel.text = self.event?.embedded?.venues.name
//                self.eventImage.image = event.image
            }
        }
    }

