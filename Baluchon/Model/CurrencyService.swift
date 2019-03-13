//
//  CurrencyService.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class CurrencyService {

    // API url
    private static let currencyURL =
    URL(string: "http://data.fixer.io/api/latest?access_key=6b9f932eab2fb32e5e0c1b3b6a078c45")!

    // Get currency from API
    static func getCurrency(callback: @escaping (Bool, Currency?) -> Void) {

        // Set request
        var request = URLRequest(url: currencyURL)
        request.httpMethod = "GET"

        // Set session
        let session = URLSession(configuration: .default)

        // Set task
        let task = session.dataTask(with: request) { (data, response, error) in

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

                guard let currency = try? JSONDecoder().decode(Currency.self, from: data) else {
                    callback(false, nil)
                    return
                }

                // Callback true
                callback(true, currency)
            }
        }

        task.resume()
    }
}
