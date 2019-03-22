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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load citylist.JSON
        loadJson()
    }

    private func loadJson() {
        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
            print("bad url")
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            print("pas de data")
            return
        }

        guard let json = try? JSONDecoder().decode(City.self, from: data) else {
            print("fuck you")
            return
        }

        print(json[0].name)
    }
}
