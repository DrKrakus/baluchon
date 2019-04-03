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
    @IBOutlet weak var selectedCityLabel: UILabel!
    @IBOutlet weak var compareWeatherButton: DesignableButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //User default selected city
        let city = SettingService.city
        selectedCityLabel.text = city

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showCityList(_:)))
        citiesListButton.addGestureRecognizer(tap)
    }

    @IBAction func didTapWeatherButton(_ sender: Any) {
       getWeather()
    }

    private func getWeather() {
        WeatherService.shared.getWeather { (success, weatherDetail) in
            if success {
                let weatherNY = weatherDetail!["newYork"]!
                let weather = weatherDetail!["selectedCity"]!

                self.newYorkTemp.text! = String(weatherNY.main.temp) + "°"
                self.newYorkDetail.text! = weatherNY.weather[0].description
                self.selectedCityTemp.text! = String(weather.main.temp) + "°"
                self.selectedCityDetail.text! = weather.weather[0].description
            } else {
                self.alertWeatherFail()
            }
        }
    }

    // Show city list
    // swiftlint:disable all
    @objc private func showCityList(_ gesture: UIGestureRecognizer) {
        let sb = self.storyboard?.instantiateViewController(withIdentifier: "CityList")
        let vc = sb as! CityListViewController
        vc.delegate = self
        self.present(vc, animated: false)
    }
}

// Protocol
extension WeatherViewController: IsAbleToReceiveData {
    // Recieve Data from another VC
    func pass(_ data: String) {
        selectedCityLabel.text = data
    }
}

// Alerts
extension WeatherViewController {
    // Alert for API fail
    private func alertWeatherFail() {
        let alertVC = UIAlertController(title: "Erreur réseau",
                                        message: "Vérifiez votre réseau et ressayez.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
}
