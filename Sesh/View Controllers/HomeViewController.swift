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
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    
    var events: [Event] = []
    let locactionManager = CLLocationManager()
    var currentLocation: String?
    var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityLabel.adjustsFontSizeToFitWidth = true
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
    func fetchCityAndState(from location: CLLocation, completion: @escaping (_ city: String?, _ state: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.administrativeArea,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return}
        fetchCityAndState(from: location) { city, state, error in
            guard let city = city, let state = state, error == nil else { return }
            self.currentLocation = (city + ", " + state)
            
        }
    }
    
    
    @IBAction func changeCityButtonTapped(_ sender: UIButton) {
        let changeCity = UIAlertController(title: "Select a City", message: "", preferredStyle: .alert)
        changeCity.addTextField { (textfield) in
            textfield.placeholder = "Enter Major City Name"
            textfield.autocapitalizationType = .words
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
        guard let city = cityLabel.text else {return}
        
        EventController.shared.fetchEventResults(with: searchTerm, with: city) { (result) in
            switch result {
            case .success(let events):
                self.events = events
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
