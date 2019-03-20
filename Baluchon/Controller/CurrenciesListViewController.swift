//
//  CurrenciesListViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 18/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class CurrenciesListViewController: UIViewController {

    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // Delegate
    weak var delegate: isAbleToReceiveData?
    // Currencies list array
    var currencies: [String] = []
    // UITableView link
    @IBOutlet weak var currenciesTableView: UITableView!

    // Close action
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get currencies list
        CurrencyService.shared.getCurrency { (success, currency) in
            if success, let currency = currency {
                //Temporary array
                var unsortedCurrencies = [String]()
                // Fill the temporary array
                for (key, _) in currency.rates {
                    unsortedCurrencies.append(key)
                }
                // Sorted array
                self.currencies = unsortedCurrencies.sorted(by: <)
                // Reload data
                self.currenciesTableView.reloadData()
            } else {
                print("Error")
            }
        }

        // Assign delegate and datasource for the uitableview
        currenciesTableView.delegate = self
        currenciesTableView.dataSource = self
    }
}

extension CurrenciesListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currenciesTableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath)

        cell.textLabel?.text = currencies[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = currenciesTableView.cellForRow(at: indexPath)

        delegate?.pass(cell!.textLabel!.text!)

        self.dismiss(animated: true)
    }
}
