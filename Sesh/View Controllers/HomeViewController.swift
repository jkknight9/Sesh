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
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        EventController.shared.fetchEventResults(with: "", with: "los angeles") { (result) in
            switch result {
            case .success(let events):
                self.events = events
                DispatchQueue.main.async {
                    self.cityLabel.text = "Los Angeles"
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // TableView Datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableViewCell else { return UITableViewCell()}
        let event = events[indexPath.row]
        cell.configureCell(event: event)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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
            guard let city = city, error == nil else { return }
            self.currentLocation = (city)
            
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
                guard let currentCityLabelText = self.currentLocation else {return}
                self.cityLabel.text = currentCityLabelText
                EventController.shared.fetchEventResults(with: "", with: currentCityLabelText, completion: { (result) in
                    switch result {
                    case .success(let events):
                        self.events = events
                        DispatchQueue.main.async {
                            if self.events.count == 0 {
                                self.tableView.setEmptyView(title: "This city is boring!", message: "No events going on here. Try a different one!")
                            }
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
            }
            
        })))
        changeCity.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (okayAction) in
            guard let newCityLabelText = changeCity.textFields?.first?.text else {return}
            self.cityLabel.text = newCityLabelText
            
            EventController.shared.fetchEventResults(with: "", with: newCityLabelText, completion: { (result) in
                switch result {
                case .success(let events):
                    self.events = events
                    DispatchQueue.main.async {
                        if self.events.count == 0 {
                            self.tableView.setEmptyView(title: "This city is boring!", message: "No events going on here. Try a different one!")
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            })
            
        }))
        present(changeCity, animated: true)
    }
    
    
    @IBAction func categoryChangedSegment(_ sender: Any) {
        guard let city = cityLabel.text else {return}
        switch categorySegment.selectedSegmentIndex {
        case 0:
            EventController.shared.fetchEventResults(with: "", with: city) { (result) in
                switch result {
                case .success(let events):
                    self.events = events
                    DispatchQueue.main.async {
                        if self.events.count == 0 {
                            self.tableView.setEmptyView(title: "This city is boring!", message: "No events going on here. Try a different one!")
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case 1:
            EventController.shared.fetchEventsBy(segmentName: "sports", with: city) { (result) in
                switch result {
                case .success(let events):
                    self.events = events
                    DispatchQueue.main.async {
                        if self.events.count == 0 {
                            self.tableView.setEmptyView(title: "No sports in the future.", message: "Try later!")
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case 2:
            EventController.shared.fetchEventsBy(segmentName: "music", with: city) { (result) in
                switch result {
                case .success(let events):
                    self.events = events
                    DispatchQueue.main.async {
                        if self.events.count == 0 {
                            self.tableView.setEmptyView(title: "No concerts in the future.", message: "Try later!")
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        case 3:
            EventController.shared.fetchEventsBy(segmentName: "Arts & Theatre", with: city) { (result) in
                switch result {
                case .success(let events):
                    self.events = events
                    DispatchQueue.main.async {
                        if self.events.count == 0 {
                            self.tableView.setEmptyView(title: "No shows in the future.", message: "Try later!")
                        }
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }

        default:
            break
        }
    }
    
     //   MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EventDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.event = events[indexPath.row]
        }
    }
}

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
