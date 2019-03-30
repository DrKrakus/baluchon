//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var newYorkTemp: UILabel!
    @IBOutlet weak var newYorkDetail: UILabel!
    @IBOutlet weak var newYorkWeatherIcon: UIImageView!
    @IBOutlet weak var selectedCityTemp: UILabel!
    @IBOutlet weak var selectedCityDetail: UILabel!
    @IBOutlet weak var selectedCityWeatherIcon: UIImageView!
    @IBOutlet weak var citiesListButton: UIStackView!
    @IBOutlet weak var compareWeatherButton: DesignableButton!

//    var citiesArray: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        WeatherService.shared.getWeather { (success, weatherDetail) in
            if success {
                let weatherNY = weatherDetail!["newYork"]!
                let weather = weatherDetail!["selectedCity"]!

                self.newYorkTemp.text! = String(weatherNY.main.temp) + "°"
                self.selectedCityTemp.text! = String(weather.main.temp) + "°"
            } else {
                print("Erreur réseaux")
            }
        }
    }

//    private func loadJson() {
//        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
//            print("bad url")
//            return
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            print("pas de data")
//            return
//        }
//
//        guard let json = try? JSONDecoder().decode(Cities.self, from: data) else {
//            print("fuck you")
//            return
//        }
//
//        for city in json {
//            let cityId = city.id
//            let cityName = city.name
//            let cityCountry = city.country
//            let city = City(id: cityId, name: cityName, country: cityCountry)
//
//            self.citiesArray.append(city)
//        }
//
//        print(self.citiesArray.first!)
//    }
}
