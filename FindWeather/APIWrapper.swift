//
//  WeatherService.swift
//  FindWeather
//
//  Created by SAIL on 12/01/24.
//

import Foundation

protocol APIService {
    func fetchData<T: Codable>(type: T.Type, url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

class APIWrapper: APIService {
    func fetchData<T: Codable>(type: T.Type,url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        
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
                let forecastData = try decoder.decode(T.self, from: data)
                completion(.success(forecastData))
                print(forecastData, " Data")
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
