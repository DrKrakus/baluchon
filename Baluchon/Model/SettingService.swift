//
//  SettingService.swift
//  Baluchon
//
//  Created by Jerome Krakus on 21/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

class SettingService {

    // Key words
    private struct Keys {
        static let currency = "currency"
        static let city = "city"
        static let cityID = "cityID"
    }

    // For chosen currency
    static var currency: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.currency) ?? "EUR"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currency)
        }
    }

    // For chosen city
    static var city: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.city) ?? "Paris, FR"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.city)
        }
    }

    static var cityID: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.cityID) ?? "6455259"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityID)
        }
    }
}
