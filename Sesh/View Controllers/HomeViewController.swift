//
//  HomeViewController.swift
//  Sesh
//
//  Created by Jack Knight on 3/18/19.
//  Copyright © 2019 Jack Knight. All rights reserved.
//

import UIKit
import CoreLocation


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    
    var events: [Event] = []
    let locactionManager = CLLocationManager()
    var currentLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locactionManager.delegate = self
        locactionManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locactionManager.requestWhenInUseAuthorization()
        locactionManager.startUpdatingLocation()

        
        tableView.delegate = self
        tableView.dataSource = self
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
    }
    
    // TableView Datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { return UITableViewCell()}
        let event = events[indexPath.row]
        cell.event = event
        return cell
    }
    
    // Get users current location
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.administrativeArea,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return}
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
           self.currentLocation = (city + ", " + country)
            
        }
    }
    
    
    @IBAction func changeCityButtonTapped(_ sender: UIButton) {
        let changeCity = UIAlertController(title: "Select a City", message: "", preferredStyle: .alert)
        changeCity.addTextField { (textfield) in
            textfield.placeholder = "Enter Major City Name"
            textfield.autocapitalizationType = .allCharacters
            textfield.autocorrectionType = .default
            
        }
        changeCity.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changeCity.addAction((UIAlertAction(title: "Use Current Location", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                self.cityLabel.text = self.currentLocation
            }
            
        })))
        changeCity.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (okayAction) in
            guard let newCityLabelText = changeCity.textFields?.first?.text else {return}
            self.cityLabel.text = newCityLabelText
            
        }))
        present(changeCity, animated: true)
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        
        EventController.fetchEventResults(with: searchTerm) { (events) in
            guard let searchedEvents = events else {return}
            self.events = searchedEvents
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
