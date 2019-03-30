//
//  WeatherService.swift
//  Baluchon
//
//  Created by Jerome Krakus on 29/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class WeatherService {

    // Singleton pattern
    static var shared = WeatherService()
    private init() {}

    // API url
    private let newYorkCity =
    URL(string: "https://api.openweathermap.org/data/2.5/weather?\(ApiKey.openWeather)&units=metric&id=5128638")!
    private let selectedCity =
    URL(string: "https://api.openweathermap.org/data/2.5/weather?\(ApiKey.openWeather)&units=metric&id=2968815")!

    // Task
    private var task: URLSessionDataTask?

    // Get weather from API
    func getWeather(callback: @escaping (Bool, [String: Weather]?) -> Void) {

        // Set session
        let session = URLSession(configuration: .default)

        // Set task
        task?.cancel()
        task = session.dataTask(with: selectedCity) { (data, response, error) in

            // Return in the main queue
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback(false, nil)
                    return
                }

                self.getWeatherForNY(completionHandler: { (weatherNY) in

                    guard let weatherNY = weatherNY else { return }

                    var weatherDetails = [String: Weather]()

                    weatherDetails["selectedCity"] = weather
                    weatherDetails["newYork"] = weatherNY

                    callback(true, weatherDetails)
                })
            }
        }

        task?.resume()
    }

    // Get the weather for New York, US
    private func getWeatherForNY(completionHandler: @escaping (Weather?) -> Void) {

        // Set session
        let session = URLSession(configuration: .default)

        // Set task
        task? = session.dataTask(with: newYorkCity) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return
                }

                guard let weatherNY = try? JSONDecoder().decode(Weather.self, from: data) else {
                    return
                }

                completionHandler(weatherNY)
            }
        }

        // Resume task
        task?.resume()
    }
}
