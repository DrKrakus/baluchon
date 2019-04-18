//
//  TranslateService.swift
//  Baluchon
//
//  Created by Jerome Krakus on 23/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class TranslateService {

    // Singleton pattern
    static var shared = TranslateService()
    private init() {}

    // API url
    private var translateURL: URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"

        guard let url = urlComponents.url else {
            fatalError("Could not create url from components")
        }

        return url
    }

    // Set session
    private var translateSession = URLSession(configuration: .default)

    // Init session for UnitTest URLSessionFake
    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

    // Task
    private var task: URLSessionDataTask?

    /// Get translatation from API
    ///
    /// - Parameter callback: Determine if the translate object is create or not and passing a string
    /// - Remark: This function is executed in the Main Queue
    func getTranslation(callback: @escaping (Bool, String?) -> Void) {

        // Set request
        let request = getURLRequest()

        // Cancel task for prevent spamming
        task?.cancel()
        // Set task
        task = translateSession.dataTask(with: request) { (data, response, error) in

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
                    print("No response from translateSession")
                    return
                }

                // Check for json decoder
                guard let responseJSON = try? JSONDecoder().decode(TranslateModel.self, from: data) else {
                    callback(false, nil)
                    print("Failed to decode translateJSON")
                    return
                }

                // Create the string
                let stringToDecode = responseJSON.data.translations.first!.translatedText

                // Get the translation quote
                callback(true, stringToDecode)
            }
        }

        // Resume task
        task?.resume()
    }

    /// Create URL for Google API
    ///
    /// - Returns: URLRequest
    private func getURLRequest() -> URLRequest {
        // Creating request
        var request = URLRequest(url: translateURL)
        // Creating body
        let body = "key=\(ApiKey.google)&q=\(Translate.shared.quote)&target=en"

        // Set request method to POST
        request.httpMethod = "POST"
        // Adding the body
        request.httpBody = body.data(using: .utf8)

        return request
    }
}
