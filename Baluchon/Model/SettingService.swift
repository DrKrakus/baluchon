//
//  SettingService.swift
//  Baluchon
//
//  Created by Jerome Krakus on 21/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class SettingService {

    private struct Keys {
        static let devise = "devise"
        static let city = "city"
    }

    static var devise: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.devise) ?? "EUR"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.devise)
        }
    }

    static var city: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.city) ?? "Paris, FR"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.city)
        }
    }
}
