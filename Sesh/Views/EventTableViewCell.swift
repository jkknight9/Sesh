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
        self.dateLabel.text = event.dates?.start?.dateTime
        self.titleLabel.text = event.name
        self.locationLabel.text = event.embedded?.venues?.first?.name
        guard let imageURL = event.image?.first?.imageURL else {return}
        ImageCacheController.shared.image(for: imageURL) { (newImage) in
            self.eventImage.image = newImage
        }
        shadowTexts()
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
    
    func shadowTexts() {
        dateLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOpacity = 0.5
        locationLabel.layer.shadowOpacity = 0.5
    }
}

