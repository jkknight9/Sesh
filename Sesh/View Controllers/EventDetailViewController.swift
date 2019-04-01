//
//  EventDetailViewController.swift
//  Sesh
//
//  Created by Jack Knight on 4/1/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var seatMapImageView: UIImageView!
    @IBOutlet weak var eventDetailLabel: UILabel!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seatMapImageView.image = nil
        
            guard let seatMapURL = self.event?.seatMap?.staticURL else {return}
            ImageCacheController.shared.image(for: seatMapURL) { (seatMapImage) in
                self.seatMapImageView.image = seatMapImage
            }
            self.eventDetailLabel.text = self.event?.info
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = event?.name
        navigationItem.prompt = event?.embedded?.venues?.first?.name
        
    }
}
