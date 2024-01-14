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
    @IBOutlet weak var tempListTable: UITableView! {
        didSet {
            self.tempListTable.delegate = self
            self.tempListTable.dataSource = self
        }
    }
    var finalLatitude = 0
    var finalLongitude = 0
    var weatherViewModel: WeatherViewModelProtocol?
    var forecastData : ForecastModel?

    override func viewWillAppear(_ animated: Bool) {
        searchBar.delegate = self
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
         searchBar.resignFirstResponder()
        print("----end",searchBar.text ?? "")
        fetchSearchLocation()
     }
    
    func fetchSearchLocation() {
        weatherViewModel?.fetchForecastData(latitude:  Double(self.finalLatitude), longitude: Double(self.finalLongitude), completion: { response in
            switch response {
            case .success(let success):
                print("Weather Data: \(success)")
                self.forecastData = success
                DispatchQueue.main.async {
                    self.tempListTable.reloadData()
                }
                
            case .failure(let failure):
                print("-----Failure", failure.localizedDescription)
            }
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("----end",searchBar.text ?? "")
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
