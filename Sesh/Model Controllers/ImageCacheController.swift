//
//  ImageCacheController.swift
//  Sesh
//
//  Created by Jack Knight on 3/28/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit

class ImageCacheController {
    
    // Singleton
    static let shared = ImageCacheController()
    
    var cached = [String: UIImage]()
    
    func image(for url: String, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = cached[url] {
            completion(cachedImage)
        } else {
            EventController.shared.fetchEventPicture(url) { (results) in
                switch results {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    self.cached[url] = image
                    self.postNewNotification()
                }
            }
        }
    }
    
    func postNewNotification() {
        DispatchQueue.main.async {
            let notification = Notification(name: Notification.Name(rawValue: "newImage"))
            NotificationCenter.default.post(notification)
            
        }
    }
}
