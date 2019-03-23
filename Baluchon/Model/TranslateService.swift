//
//  TranslateService.swift
//  Baluchon
//
//  Created by Jerome Krakus on 23/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class TranslateService {

    static var shared = TranslateService()
    private init() {}

    private let url = URL(string: "https://translation.googleapis.com/language/translate/v2")!

    // Task
    private var task: URLSessionDataTask?

    // Get translation from API
    func getTranslation(callback: @escaping (Bool, TranslateModel?) -> Void) {

        // Set request
        var request = URLRequest(url: url)
        let body = "key=AIzaSyBab4AnT8ezqFOs0Dy5-aXRt6pm1ofzs28&q=\(Translate.shared.quote)&target=en"
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)

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

                guard let responseJSON = try? JSONDecoder().decode(TranslateModel.self, from: data) else {
                    callback(false, nil)
                    return
                }

                // Get the translation quote
                callback(true, responseJSON)
            }
        }

        task?.resume()
    }
}
