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
    private let currencyURL =
    URL(string: "http://data.fixer.io/api/latest?access_key=6b9f932eab2fb32e5e0c1b3b6a078c45")!

    // Task
    private var task: URLSessionDataTask?

    // Get currency from API
    func getCurrency(callback: @escaping (Bool) -> Void) {

        // Set request
        var request = URLRequest(url: CurrencyService().currencyURL)
        request.httpMethod = "GET"

        // Set session
        let session = URLSession(configuration: .default)

        // Set task
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in

            // Return in the main queue
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode(Currency.self, from: data) else {
                    callback(false)
                    return
                }

                // Creating let for Currency
//                let success = responseJSON.success
//                let timestamp = responseJSON.timestamp
//                let base = responseJSON.base
//                let date = responseJSON.date
//                let rates = responseJSON.rates

                // Creating Currency
                Currency.shared.base = responseJSON.base
                Currency.shared.date = responseJSON.date
                Currency.shared.rates = responseJSON.rates

                // Callback true
                callback(true)
            }
        }

        task?.resume()
    }
}
