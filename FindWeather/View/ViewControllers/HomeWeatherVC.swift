//
//  HomeWeatherVC.swift
//  FindWeather
//
//  Created by SAIL on 11/01/24.
//

import UIKit
import CoreLocation

class HomeWeatherVC: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var weatherNameLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var fahrenheitLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var todayWeatherCollView : UICollectionView!{
        didSet {
            self.todayWeatherCollView.delegate = self
            self.todayWeatherCollView.dataSource = self
        }
    }
    
    let locationManager = CLLocationManager()
    var timer: Timer?
    let dynamicLatitude = 12.9675
    let dynamicLongitude = 80.1491
    
    public var weatherViewModel: WeatherViewModelProtocol?
    var weatherData: WeatherModel?
    
    init(weatherViewModel: WeatherViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.weatherViewModel = weatherViewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.coreLocation()
        self.today()
        if let tapImage = searchImage {
            tapImage.addAction(for: .tap) {
                self.navigateToSearchViewController()
            }
        }
        fetchWeatherAPI { [weak self] (success) in
            guard let `self` = self  else {return}
            if success {
                self.loadAllWeatherData()
            }
        }
    }
    
    private func loadAllWeatherData(){
        if  let tempData = weatherData?.main?.temp, let pressure = weatherData?.main?.pressure, let f = weatherData?.main?.feelsLike, let place = weatherData?.name
        {
            temperatureLabel.text = String(self.fahrenheitToCelsius(fahrenheit:Double(tempData)).rounded())
            pressureLabel.text = String(pressure)
            fahrenheitLabel.text = String(f)
            weatherNameLabel.text = place
            
        }
    }
    
    
    @IBAction func nextFiveDaysAc(_ sender: Any) {
        self.navigateToSearchViewController()
    }
    
    private func navigateToSearchViewController() {
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationWeatherVC") as! SearchLocationWeatherVC
        searchVC.weatherViewModel = weatherViewModel
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func coreLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let firstRange = NSRange(location: 0, length: 8)
        let secondRange = NSRange(location: 9, length: 9)
        let titleattributeString = NSMutableAttributedString(string: "Bandung, Indonesia")
        titleattributeString.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor.black, range: firstRange)
        titleattributeString.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor.gray, range: secondRange)
        titleattributeString.addAttribute(NSMutableAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 28), range: firstRange)
        titleattributeString.addAttribute(NSMutableAttributedString.Key.font, value: UIFont.systemFont(ofSize: 25), range: secondRange)
        if let location = locationNameLabel {
            location.attributedText = titleattributeString
        }
    }
    func fahrenheitToCelsius(fahrenheit: Double) -> Double {
        return (fahrenheit - 32) / 1.8
    }
    
    func today() {
        timer?.invalidate()
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        let formattedDate = dateFormatter.string(from: currentDate)
        if let today = todayLabel {
            today.text = formattedDate
        }
    }
    
    func fetchWeatherAPI(completion:@escaping(Bool)->Void) {
        weatherViewModel?.fetchWeatherData(latitude: dynamicLatitude, longitude: dynamicLongitude) { result in
            switch result {
            case .success(let weatherModel):
                print("Weather Data: \(weatherModel)")
                DispatchQueue.main.async {
                    self.weatherData = weatherModel
                    if let collectionView = self.todayWeatherCollView {
                        collectionView.reloadData()
                    }
                    completion(true)
                }
            case .failure(let error):
                print("Weather Data API Failure: \(error)")
                completion(false)
            }
        }
    }
    
}
