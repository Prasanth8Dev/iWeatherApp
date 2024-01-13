//
//  WeatherService.swift
//  FindWeather
//
//  Created by SAIL on 12/01/24.
//

import Foundation

protocol APIService {
    func fetchData(url: URL, completion: @escaping (Result<WeatherModel, Error>) -> Void)
}


class APIWarpper: APIService {
    func fetchData(url: URL, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherModel.self, from: data)
                completion(.success(weatherData))
                print(weatherData,"Weather Data")
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
