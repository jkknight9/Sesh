//
//  EventDetailViewController.swift
//  Sesh
//
//  Created by Jack Knight on 4/1/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var seatMapImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        self.eventTitleLabel.text = self.event?.name
        self.scrollView.zoomScale = 0.5
        self.seatMapImageView.image = nil
        if let seatMapURL = self.event?.seatMap?.staticURL {
            ImageCacheController.shared.imageWithCompletion(for: seatMapURL) { (seatMapImage) in
                self.seatMapImageView.image = seatMapImage
            }
        } else if let image = event?.image?.first?.imageURL{
            ImageCacheController.shared.imageWithCompletion(for: image) { (image) in
                self.seatMapImageView.image = image
            }
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return seatMapImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.title = FormatDate.convert(isoString: event?.dates?.start?.dateTime)
        navigationItem.prompt = event?.embedded?.venues?.first?.name
        
    }
}
