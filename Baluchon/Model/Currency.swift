//
//  Currency.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class Currency: Codable {
    // Singleton pattern
    static let shared = Currency()
    private init() {}

    // Properties
    var base, date: String?
    var rates: [String: Double]?
}
