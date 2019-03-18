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

    // API url
    private static let currencyURL =
    URL(string: "http://data.fixer.io/api/latest?access_key=6b9f932eab2fb32e5e0c1b3b6a078c45")!

    // Task
    private var task: URLSessionDataTask?

    // Get currency from API
    func getCurrency(callback: @escaping (Bool, Currency?) -> Void) {

        // Set request
        var request = URLRequest(url: CurrencyService.currencyURL)
        request.httpMethod = "GET"

        // Set session
        let session = URLSession(configuration: .default)

        // Set task
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in

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

                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    callback(false, nil)
                    return
                }

                // Creating Currency
                let success = responseJSON.success
                let timestamp = responseJSON.timestamp
                let base = responseJSON.base
                let date = responseJSON.date
                let rates = responseJSON.rates
                let currency = Currency(success: success,
                                        timestamp: timestamp,
                                        base: base,
                                        date: date,
                                        rates: rates)

                // Callback true
                callback(true, currency)
            }
        }

        task?.resume()
    }
}
