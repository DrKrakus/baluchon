//
//  CurrencyService.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class CurrencyService {

    // Singleton pattern
    static var shared = CurrencyService()
    private init() {}

    // Construct API url
    private var currencyURL: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "http"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/api/latest"
        urlComponents.queryItems = [URLQueryItem(name: "access_key", value: ApiKey.fixer)]

        guard let url = urlComponents.url else {
            fatalError("Could not create url from components")
        }

        return url
    }

    // Session
    private var currencySession = URLSession(configuration: .default)

    // Init session for UnitTest URLSessionFake
    init(currencySession: URLSession) {
        self.currencySession = currencySession
    }

    // Task
    private var task: URLSessionDataTask?

    /// Get currency from API
    ///
    /// - Parameter callback: Determine if the currency object is create or not
    /// - Remark: This function is executed in the Main Queue
    func getCurrency(callback: @escaping (Bool) -> Void) {
        // Cancel task for prevent spamming
        task?.cancel()
        // Set task
        task = currencySession.dataTask(with: currencyURL) { (data, response, error) in

            // Return in the main queue
            DispatchQueue.main.async {
                // Check for data and no error
                guard let data = data, error == nil else {
                    callback(false)
                    // Print the error
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    return
                }

                // Check for the response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false)
                    print("No response from currencySession")
                    return
                }

                // Check for the json decoder
                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    callback(false)
                    print("Failed to decode currencyJSON")
                    return
                }

                // Creating Currency
                Currency.shared.base = responseJSON.base
                Currency.shared.date = responseJSON.date
                Currency.shared.rates = responseJSON.rates
                callback(true)
            }
        }

        // Resumes the task
        task?.resume()
    }
}
