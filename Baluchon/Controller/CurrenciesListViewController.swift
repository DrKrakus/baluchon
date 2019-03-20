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
    weak var delegate: IsAbleToReceiveData?
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
        getCurrencyList()
    }

    // Get the currency list
    private func getCurrencyList() {
        // Check for same date
        guard checkForSameDate() else {
            print("API")
            // Get currencies list from API if note same date
            CurrencyService.shared.getCurrency { (success) in
                if success {
                    self.fillCurrencies()
                } else {
                    self.alertListFail()
                }
            }
            return
        }

        print("NOT API")
        // If same date
        self.fillCurrencies()
    }

    // Check the date
    private func checkForSameDate() -> Bool {
        // Get the current date and compare
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())

        guard let apiDate = Currency.shared.date, apiDate == date else { return false }

        return true
    }

    // Fill the currencies array
    private func fillCurrencies() {
        //Temporary array
        var unsortedCurrencies = [String]()
        // Fill the temporary array
        for (key, _) in Currency.shared.rates! {
            unsortedCurrencies.append(key)
        }
        // Sorted array
        self.currencies = unsortedCurrencies.sorted(by: <)
        // Reload data
        self.currenciesTableView.reloadData()
    }
}

// UITableView
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

// Alert
extension CurrenciesListViewController {
    // Alert for API fail
    private func alertListFail() {
        let alertVC = UIAlertController(title: "Erreur réseau",
                                        message: "Impossible de récupérer la liste, vérifiez votre réseau et ressayez.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
}
