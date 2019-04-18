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
    private var newYorkCityURL: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "APPID", value: ApiKey.openWeather),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "id", value: "5128638")
        ]

        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }

        return url
    }

    private var selectedCityURL: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "APPID", value: ApiKey.openWeather),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "id", value: SettingService.cityID)
        ]

        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }

        return url
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

    /// Get weather from API
    ///
    /// - Parameter callback: Determine if the translate object is create or not and passing a dictionnary
    /// - Remark: This function is executed in the Main Queue
    func getWeather(callback: @escaping (Bool, [String: Weather]?) -> Void) {

        // Cancel task for prevent spamming
        task?.cancel()
        // Set task
        task = weatherSession.dataTask(with: selectedCityURL) { (data, response, error) in

            // Return in the main queue
            DispatchQueue.main.async {
                // Check for data and no error
                guard let data = data, error == nil else {
                    callback(false, nil)
                    // Print the error
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }

                // Check for response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    print("No response from weatherSession")
                    return
                }

                // Check for json decoder
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback(false, nil)
                    print("Failed to decode weatherJSON")
                    return
                }

                // Get weather for NY
                self.getWeatherForNY(completionHandler: { (weatherNY) in

                    // Check for weatherNY object
                    guard let weatherNY = weatherNY else {
                        callback(false, nil)
                        return
                    }

                    // Creating empty dictionnary
                    var weatherDetails: [String: Weather] = [:]

                    // Fill the dictionnary
                    weatherDetails["selectedCity"] = weather
                    weatherDetails["newYork"] = weatherNY

                    // Passing the dictionnary
                    callback(true, weatherDetails)
                })
            }
        }

        // Resume task
        task?.resume()
    }

    /// Get weather from API
    ///
    /// - Parameter completionHandler: Passing a Weather object, can be nil
    /// - Remark: This function is executed in the Main Queue
    private func getWeatherForNY(completionHandler: @escaping (Weather?) -> Void) {

        // Set task
        task? = weatherNYSession.dataTask(with: newYorkCityURL) { (data, response, error) in
            DispatchQueue.main.async {
                // Check for data and no error
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    // Print the error
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }

                // Check for response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    print("No response from weatherNYSession")
                    return
                }

                // Check for json decoder
                guard let weatherNY = try? JSONDecoder().decode(Weather.self, from: data) else {
                    completionHandler(nil)
                    print("Failed to decode weatherNYJSON")
                    return
                }

                // Passing weather object
                completionHandler(weatherNY)
            }
        }

        // Resume task
        task?.resume()
    }
}
