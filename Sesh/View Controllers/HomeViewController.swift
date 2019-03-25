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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locactionManager.delegate = self
        locactionManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func changeCityButtonTapped(_ sender: UIButton) {
    let changeCity = UIAlertController(title: "Select a City", message: "", preferredStyle: .alert)
//        let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 120.0))
//        view.backgroundColor = UIColor.green)
        changeCity.addTextField { (textfield) in
            textfield.placeholder = "Enter Major City Name"
            textfield.autocapitalizationType = .sentences
            textfield.autocorrectionType = .default
            
        }
        changeCity.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changeCity.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (okayAction) in
            guard let newCityLabelText = changeCity.textFields?.first?.text else {return}
            self.cityLabel.text = newCityLabelText
            
        }))
        present(changeCity, animated: true)
    }
    }
    
    


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
