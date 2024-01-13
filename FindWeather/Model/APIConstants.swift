//
//  APIConstants.swift
//  FindWeather
//
//  Created by SAIL on 12/01/24.
//https://api.openweathermap.org/data/2.5/onecall?lat=12.9675&lon=80.1491&appid=4cd569ffb3ecc3bffe9c0587ff02109f

import Foundation

struct APIConstants {
    static let apiKey = "4cd569ffb3ecc3bffe9c0587ff02109f"
    static let baseURL = "https://api.openweathermap.org/data/2.5/"

    static func weatherURL(latitude: Double, longitude: Double) -> URL {
        let urlString = "\(baseURL)weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        return URL(string: urlString)!
    }

    static func forecastURL(latitude: Double, longitude: Double) -> URL {
        let urlString = "\(baseURL)onecall?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        return URL(string: urlString)!
    }
}
