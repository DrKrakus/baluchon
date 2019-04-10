//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by Jerome Krakus on 10/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
// swiftlint:disable force_try
class FakeResponseData {

    // Bundle identifier
    private static let bundle = Bundle(for: FakeResponseData.self)

    // For Currency Fake Data
    static var currencyCorrectData: Data? {
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    // For Weather Fake Data
    static var weatherCorrectData: Data? {
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    // For NY Weather Fake Data
    static var weatherNYCorrectData: Data? {
        let url = bundle.url(forResource: "WeatherNY", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    // For Translate Fake Data
    static var translateCorrectData: Data? {
        let url = bundle.url(forResource: "Translate", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    // For Incorrect Data
    static var incorrectData: Data? {
        let data = "error".data(using: .utf8)!
        return data
    }

    // For Correct HTTP Response
    static var reponseOK = HTTPURLResponse(
        url: URL(string: "https://www.google.fr")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    // For Correct HTTP Response
    static var reponseKO = HTTPURLResponse(
        url: URL(string: "https://www.google.fr")!,
        statusCode: 500, httpVersion: nil, headerFields: nil)!

    // For Error Fake
    class FakeError: Error {}
    static let error = FakeError()

}
