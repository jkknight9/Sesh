//
//  AppDelegate.swift
//  Sesh
//
//  Created by Jack Knight on 3/18/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var venue: Venue?
    var event: Event?
    
    let notificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()
    static let geoCoder = CLGeocoder()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted {
                return
            }
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits()
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.stopUpdatingLocation()
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        ImageCacheController.shared.purgeCache()
    }

    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let _ = placemarks?.first {
                self.newVisitsReceived(visit)
            }
        }
    }
    
    func newVisitsReceived(_ visit: CLVisit) {
       // need to set the location of the event to the clvisit
        let event = Event(visit: visit)
        let content = UNMutableNotificationContent()
        guard let eventName = event.name else {return}
        content.title = "Are you at \(eventName)?"
        content.body = "Would you like to see the options?"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        guard let eventDateString = event.dates?.start?.dateTime else {return}
        let request = UNNotificationRequest(identifier: eventDateString, content: content, trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: nil)
    }
}


