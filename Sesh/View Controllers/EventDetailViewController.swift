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
    @IBOutlet weak var eventDetailLabel: UILabel!
    
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        self.scrollView.zoomScale = 0.5
        self.seatMapImageView.image = nil
        guard let seatMapURL = self.event?.seatMap?.staticURL else {return}
        ImageCacheController.shared.image(for: seatMapURL) { (seatMapImage) in
            self.seatMapImageView.image = seatMapImage
        }
        self.eventDetailLabel.text = self.event?.info
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return seatMapImageView
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = event?.name
        navigationItem.prompt = event?.embedded?.venues?.first?.name
        
    }
}
