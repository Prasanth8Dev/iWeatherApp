//
//  WeatherViewModel.swift
//  FindWeather
//
//  Created by SAIL on 12/01/24.
//

import Foundation

protocol WeatherViewModelProtocol {
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void)
    func fetchForecastData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void)
}

class WeatherViewModel : WeatherViewModelProtocol {
    private let service: APIService

    init(service: APIService) {
        self.service = service
    }

    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let weatherURL = APIConstants.weatherURL(latitude: latitude, longitude: longitude)
        service.fetchData(url: weatherURL, completion: completion)
    }

    func fetchForecastData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let forecastURL = APIConstants.forecastURL(latitude: latitude, longitude: longitude)
        service.fetchData(url: forecastURL, completion: completion)
    }
}
