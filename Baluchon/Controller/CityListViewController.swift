//
//  CityListViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 03/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {

    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Delegate
    weak var delegate: IsAbleToReceiveData?
    // Array of city
    var citiesArray: [City] = []
    // Search for city
    var searchCity = [City]()
    var searching = false
    // Throttling item
    private var pendingRequestWorkItem: DispatchWorkItem?

    // Outlets
    @IBOutlet weak var cityListTableView: UITableView!
    @IBOutlet weak var loadingView: DesignableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Change the separator and scroll color
        cityListTableView.separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3004066781)
        cityListTableView.indicatorStyle = .white

        // Change the background color for cells
        let clearView = UIView()
        clearView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        UITableViewCell.appearance().selectedBackgroundView = clearView

        // Change cursor color for searchbar
        UITextField.appearance(whenContainedInInstancesOf: [type(of: searchBar)]).tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        // Get city list
        getCityList()
    }

    // Close button
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    private func getCityList() {
        guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
            return
        }

        guard let data = try? Data(contentsOf: url) else {
            return
        }

        guard let json = try? JSONDecoder().decode(Cities.self, from: data) else {
            return
        }

        for city in json {
            let cityId = city.id
            let cityName = city.name
            let cityCountry = city.country
            let city = City(id: cityId, name: cityName, country: cityCountry)

            self.citiesArray.append(city)
        }

        loadingView.isHidden = true
        cityListTableView.reloadData()
    }
}

// TableView Delegate
extension CityListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCity.count
        } else {
            return citiesArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityListTableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)

        if searching {
            let currentFiltredCity = searchCity[indexPath.row]
            cell.textLabel?.text = currentFiltredCity.name + ", " + currentFiltredCity.country
        } else {
            let currentCity = citiesArray[indexPath.row]
            cell.textLabel?.text = currentCity.name + ", " + currentCity.country
        }

        cell.textLabel?.textColor = .white

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cityListTableView.cellForRow(at: indexPath)!
        var selectedCity: City
        var selectedCityID: String

        if searching {
            searchBar.resignFirstResponder()
            selectedCity = searchCity[indexPath.row]
            selectedCityID = String(selectedCity.id)
        } else {
            selectedCity = citiesArray[indexPath.row]
            selectedCityID = String(selectedCity.id)
        }

        guard let selectedCityName = cell.textLabel?.text else { return }

        // Save city name & city ID
        SettingService.city = selectedCityName
        SettingService.cityID = selectedCityID
        // Pass the devise back to the CurrencyVC
        delegate?.passCity(selectedCity)

        self.dismiss(animated: true)
    }
}

// SearchBar Delegate
extension CityListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searching = true
        pendingRequestWorkItem?.cancel()

        let requestWorkItem = DispatchWorkItem { [weak self] in
            DispatchQueue.global(qos: .background).async {
                self!.searchCity = self!.citiesArray.filter({
                    $0.name.lowercased().prefix(searchText.count) == searchText.lowercased()
                })

                DispatchQueue.main.async {
                    self!.cityListTableView.reloadData()
                }
            }
        }

        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: requestWorkItem)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        cityListTableView.reloadData()
    }
}
