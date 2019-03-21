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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var event: Event? {
        didSet {
            updateViews()
        }
    }
        func updateViews() {
        
        guard let event = event else { return}
            DispatchQueue.main.async {
                self.dateLabel.text = "\(event.date)"
                self.timeLabel.text = "\(event.time)"
                self.titleLabel.text = "\(event.name)"
                self.locationLabel.text = "\(event.locationName)"
            }
        }
    }

