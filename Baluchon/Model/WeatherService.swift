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

    // API urls
    // swiftlint:disable line_length
    private let newYorkCity = URL(string: "https://api.openweathermap.org/data/2.5/weather?" + "\(ApiKey.openWeather)&units=metric&lang=fr&id=5128638")!

    private var selectedCity: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?" + "\(ApiKey.openWeather)&units=metric&lang=fr&id=\(SettingService.cityID)")!
    }

    // Set session
    private var weatherSession = URLSession(configuration: .default)
    private var weatherNYSession = URLSession(configuration: .default)

    // Init session for UnitTest URLSessionFake
    init(weatherSession: URLSession, weatherNYSession: URLSession) {
        self.weatherSession = weatherSession
        self.weatherNYSession = weatherNYSession
    }

    // Task
    private var task: URLSessionDataTask?

    // Get weather from API
    func getWeather(callback: @escaping (Bool, [String: Weather]?) -> Void) {

        // Set task
        task?.cancel()
        task = weatherSession.dataTask(with: selectedCity) { (data, response, error) in

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
                    print("Json fail")
                    callback(false, nil)
                    return
                }

                self.getWeatherForNY(completionHandler: { (weatherNY) in

                    guard let weatherNY = weatherNY else {
                        callback(false, nil)
                        return
                    }

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

        // Set task
        task? = weatherNYSession.dataTask(with: newYorkCity) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }

                guard let weatherNY = try? JSONDecoder().decode(Weather.self, from: data) else {
                    completionHandler(nil)
                    return
                }

                completionHandler(weatherNY)
            }
        }

        // Resume task
        task?.resume()
    }
}
