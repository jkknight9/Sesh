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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var venue: Venue?
    
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
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        ImageCacheController.shared.purgeCache()
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        guard let unwrappedLatitude =  venue?.location?.latitude else {return}
        guard let unwrappedLongitude = venue?.location?.longitude else {return}
        guard let latitude = CLLocationDegrees(unwrappedLatitude) else {return}
        guard let longitude = CLLocationDegrees(unwrappedLongitude) else {return}
        let clLocation = CLLocation(latitude: latitude, longitude: longitude)
        
    }
    
    func newVisitsReceived(_ visit: CLVisit) {
        let newLocation = 
    }
}

