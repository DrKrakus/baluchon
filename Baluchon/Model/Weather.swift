//
//  Weather.swift
//  Baluchon
//
//  Created by Jerome Krakus on 29/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
// swiftlint:disable identifier_name
// Struct for matching Json response
struct Weather: Codable {
    let weather: [WeatherElement]
    let main: Main
    let id: Int
}

struct Main: Codable {
    let temp: Double
}

struct WeatherElement: Codable {
    let description, main: String
}
