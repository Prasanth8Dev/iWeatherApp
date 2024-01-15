//
//  HomeWeatherVC.swift
//  FindWeather
//
//  Created by SAIL on 11/01/24.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView


class HomeWeatherVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var todayWeatherCollView : UICollectionView!{
        didSet {
            self.todayWeatherCollView.delegate = self
            self.todayWeatherCollView.dataSource = self
        }
    }
    var locationDataClosure: ((_ lat:Double, _ lon:Double) -> Void)?
    
    let locationManager = CLLocationManager()
    var timer: Timer?
    var dynamicLatitude = 0.0
    var dynamicLongitude = 0.0
    let concurrentThread = DispatchGroup()
    
    public var weatherViewModel: WeatherViewModelProtocol?
    var weatherData: WeatherModel?
    var forecastData : ForecastModel?
    var refreshControl = UIRefreshControl()
//    @IBOutlet var circularProgressBar: LoaderAnimation!
    var loader: NVActivityIndicatorView!
   
    
    
    init(weatherViewModel: WeatherViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.weatherViewModel = weatherViewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLoader()
        self.mainView.isHidden = true
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.mainView.addSubview(refreshControl)
    }
    private func initLoader() {
        loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60),type: .ballClipRotateMultiple,color: .cyan)
        loader.center = self.view.center
        self.view.addSubview(loader)
        loader.startAnimating()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("-----",self.mainView.frame.height)
       // scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.mainView.frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserLocation()
        self.today()
        if let tapImage = searchImage {
            tapImage.addAction(for: .tap) {
                self.navigateToSearchViewController()
            }
        }
  
       
    }
    
    private func fetchUserLocation(){
        self.coreLocation()
        self.locationDataClosure = { lat,lon in
            self.dynamicLatitude = lat
            self.dynamicLongitude = lon
            self.loadCurrentLocationWeather()
        }
    }

    private func loadCurrentLocationWeather() {
        // Loader start
        var fetchWeatherSuccess = false
        concurrentThread.enter()
        fetchWeatherAPI { [weak self] (success) in
            guard let `self` = self  else {return}
            if success {
                fetchWeatherSuccess = success
                self.concurrentThread.leave()
            } else {
                self.concurrentThread.leave()
            }
        }
        concurrentThread.enter()
        fetchForecastAPI { [weak self] (success) in
            guard let `self` = self  else {return}
            if success {
                print(success, "fetchForecastAPI success")
                fetchWeatherSuccess = success
                self.concurrentThread.leave()
            } else {
                self.concurrentThread.leave()
            }
        }
        concurrentThread.notify(queue: .main){
            self.loader.stopAnimating()
            if fetchWeatherSuccess {
                DispatchQueue.main.async {
                    self.mainView.isHidden = false
                    self.todayWeatherCollView.reloadData()
                    self.loadAllWeatherData()
                    // Loader Stop
                }
            }
        }
    }
    
    @objc func refreshData() {
        loadCurrentLocationWeather()
       // self.todayWeatherCollView.reloadData()
        self.refreshControl.endRefreshing()
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
    func convertTimestampToDate(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    private func loadAllWeatherData(){
        if let data = weatherData, let tempData = weatherData?.main?.temp, let pressure = weatherData?.main?.pressure, let f = weatherData?.main?.feelsLike, let place = weatherData?.name, let locationName = self.forecastData?.timezone {
            temperatureLabel.text = String(self.fahrenheitToCelsius(fahrenheit:Double(tempData)).rounded())
            pressureLabel.text = String(pressure)
            fahrenheitLabel.text = String(f)
            weatherNameLabel.text = place
            sunriseLabel.text = String(convertTimestampToDate(timestamp: TimeInterval(data.sys?.sunrise ?? 0)))
            windLabel.text = "\(data.wind?.speed?.rounded() ?? 0)"
            locationNameLabel.text = String(locationName)
        }
    }
    
    func fetchWeatherAPI(completion:@escaping(Bool)->Void) {
        weatherViewModel?.fetchWeatherData(latitude: self.dynamicLatitude, longitude: self.dynamicLongitude) { result in
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
    
    func fetchForecastAPI(completion: @escaping (Bool)->Void) {
        weatherViewModel?.fetchForecastData(latitude:  Double(self.dynamicLatitude), longitude: Double(self.dynamicLongitude), completion: { response in
            switch response {
            case .success(let success):
                print("fetchForecastAPI Data: \(success)")
                self.forecastData = success
              
                completion(true)
            case .failure(let failure):
                print("-----Failure", failure.localizedDescription)
                completion(false)
            }
        })
    }
}
