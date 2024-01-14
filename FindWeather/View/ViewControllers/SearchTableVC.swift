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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabCell = tempListTable.dequeueReusableCell(withIdentifier: "TempListTable", for: indexPath) as! TempListTable
        return tabCell
    }
    
    
}

class TempListTable : UITableViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
}
