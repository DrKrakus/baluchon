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
    func getTranslation(callback: @escaping (Bool, String?) -> Void) {

        // Set request
        var request = URLRequest(url: url)
        let body = "key=\(ApiKey.google)&q=\(Translate.shared.quote)&target=en"
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

                // Converting for a valid aposthrope text
                let stringToDecode = responseJSON.data.translations[0].translatedText
                let validString = stringToDecode.replacingOccurrences(of: "&#39;", with: "'")

                // Get the translation quote
                callback(true, validString)
            }
        }

        task?.resume()
    }
}
