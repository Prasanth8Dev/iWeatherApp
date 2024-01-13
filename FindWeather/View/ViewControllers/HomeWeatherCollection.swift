//
//  HomeWeatherCollection.swift
//  FindWeather
//
//  Created by SAIL on 11/01/24.
//

import UIKit
import Foundation
import CoreLocation


extension HomeWeatherVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collCell  = todayWeatherCollView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell
        if let weatherData = weatherData?.main {
            print(weatherData, "______WeatherCollectionViewCell")
            collCell.temp_Lbl.text = "\(weatherData.temp ?? 0)"

        }
        return collCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 200)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    if let city = placemark.locality,
                       let state = placemark.administrativeArea {
                        if let locName = self.locationNameLabel {
                            locName.text = "\(city), \(state)"
                        }
                    } else {
                        if let locName = self.locationNameLabel {
                            locName.text = "Location not available"
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}


class WeatherCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var weekDays_Lbl: UILabel!
    @IBOutlet weak var weather_Img: UIImageView!
    @IBOutlet weak var temp_Lbl: UILabel!
    
}
