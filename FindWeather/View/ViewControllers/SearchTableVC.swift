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
        let tabCell = tempList_Table.dequeueReusableCell(withIdentifier: "TempListTable", for: indexPath) as! TempListTable
        return tabCell
    }
    
    
}

class TempListTable : UITableViewCell {
    
}
