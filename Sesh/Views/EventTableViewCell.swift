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
    
    var event: Event?
    
    func configureCell(event: Event) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNewPhotoNotification), name: Notification.Name(rawValue: "newImage"), object: nil)
        self.eventImage.image = nil
        self.event = event
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let exampleDate = event.dates?.start?.dateTime else {return}
        guard let date = dateFormatter.date(from: exampleDate) else {return}
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let formattedDate  = dateFormatter.string(from: date)
        self.dateLabel.text = formattedDate
        self.titleLabel.text = event.name
        self.locationLabel.text = event.embedded?.venues?.first?.name
        guard let imageURL = event.image?.first?.imageURL else {return}
        ImageCacheController.shared.image(for: imageURL) { (newImage) in
            self.eventImage.image = newImage
        }
        shadowText()
    }
    
    @objc func processNewPhotoNotification() {
        guard let imageURL = self.event?.image?.first?.imageURL else {return}
        ImageCacheController.shared.image(for: imageURL) { (newImage) in
            self.eventImage.image = newImage
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func shadowText() {
        titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowRadius = 1.0
        dateLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        dateLabel.layer.shadowOpacity = 1.0
        dateLabel.layer.shadowRadius = 1.0
        locationLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        locationLabel.layer.shadowOpacity = 1.0
        locationLabel.layer.shadowRadius = 1.0
    }
}

