//
//  SearchLocationWeatherVC.swift
//  FindWeather
//
//  Created by SAIL on 11/01/24.
//

import UIKit
import CoreLocation

class SearchLocationWeatherVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tempList_Table: UITableView! {
        didSet {
            self.tempList_Table.delegate = self
            self.tempList_Table.dataSource = self
        }
    }
    var finalLatitude = 0
    var finalLongitude = 0
    var weatherViewModel: WeatherViewModelProtocol?
    
   // var weatherViewModel = WeatherViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.delegate = self
        // If you want to show the keyboard immediately when the view appears
        searchBar.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("-------",searchText)
        if searchText.count > 0 {
            self.getCoordinates(from: searchText) { coordinates, error in
                guard error == nil else {return}
                if let currentCoordinates = coordinates {
                    self.finalLatitude = Int(currentCoordinates.latitude)
                    self.finalLongitude = Int(currentCoordinates.longitude)
                    print("------coordinates latitude",currentCoordinates.latitude)
                    print("------coordinates longitude",currentCoordinates.longitude)
                    
                }
            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         // Hide the keyboard when the "Search" button is tapped
         searchBar.resignFirstResponder()
        print("----end",searchBar.text)
        fetchSearchLocation()
         
         // Perform any additional search-related actions here
     }
    func fetchSearchLocation() {
        weatherViewModel?.fetchForecastData(latitude: Double(self.finalLatitude), longitude: Double(self.finalLongitude), completion: { response in
            switch response {
            case .success(let success):
                print("Weather Data: \(success)")
               
                
            case .failure(let failure):
                print("-----Failure", failure.localizedDescription)
            }
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("----end",searchBar.text)
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCoordinates(from address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let firstPlacemark = placemarks?.first,
               let location = firstPlacemark.location?.coordinate {
                completion(location, nil)
            } else {
                print("No location found for address: \(address)")
                completion(nil, nil)
            }
        }
    }
}
