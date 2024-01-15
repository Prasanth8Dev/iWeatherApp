//
//  SearchTableVC.swift
//  FindWeather
//
//  Created by SAIL on 11/01/24.
//

import Foundation
import UIKit


extension SearchLocationWeatherVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabCell = tempListTable.dequeueReusableCell(withIdentifier: "TempListTable", for: indexPath) as! TempListTable
        if let forecastModel = forecastData {
            tabCell.descriptionLabel.text = forecastModel.daily[indexPath.row].weather[0].description
            tabCell.tempLabel.text = String(forecastModel.daily[indexPath.row].temp.day)
            if let icon = forecastData?.daily[indexPath.row].weather[0].icon ,let imgURL = URL(string: "https://openweathermap.org/img/w/\(icon).png") {
                tabCell.weatherImage.kf.setImage(with: imgURL)
            }
        }
        return tabCell
    }
}

class TempListTable : UITableViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
}
