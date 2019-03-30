//
//  City.swift
//  Baluchon
//
//  Created by Jerome Krakus on 22/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation
// swiftlint:disable identifier_name
typealias Cities = [City]

struct City: Codable {
    let id: Int
    let name, country: String
}
