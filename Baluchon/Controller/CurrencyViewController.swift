//
//  CurrencyViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit
import Foundation

class CurrencyViewController: UIViewController {

    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var convertedAmountLabel: UILabel!
    @IBOutlet weak var deviseButton: UIStackView!
    @IBOutlet weak var deviseLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var converterButton: DesignableButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    // MARK: Action
    @IBAction func didTapConverterButton(_ sender: Any) {
        convertCurrency()
    }

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Disable the converterButton
        converterButton.isEnabled = false

        // Asign the UITextFieldDelegate to amountTextField
        amountTextField.delegate = self
        // Change the color of cursor
        amountTextField.tintColor = .white
        // Change the textfield style
        setTextFieldStyle()

        //User default devise
        let devise = UserDefaults.standard.string(forKey: "devise") ?? "EUR"
        deviseLabel.text = devise

        // Create and add the gesture for deviseButton
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showCurrencies(_:)))
        deviseButton.addGestureRecognizer(tap)
    }

    // Show currencies
    // swiftlint:disable all
    @objc func showCurrencies(_ gesture: UIGestureRecognizer) {
        let sb = self.storyboard?.instantiateViewController(withIdentifier: "CurrenciesList")
        let vc = sb as! CurrenciesListViewController
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    private func convertCurrency() {
        // Checking the date
        guard checkForSameDate() else {
            // Hiding the button and show the loader
            converterButton.isHidden = true
            loader.isHidden = false

            // If not the same date
            CurrencyService.shared.getCurrency { (success) in
                // Showing the button and hide the loader
                self.converterButton.isHidden = false
                self.loader.isHidden = true
                
                if success {
                    self.convertingCurrency()
                } else {
                    self.alertCurrencyFail()
                }
            }
            return
        }

        // If the same date
        convertingCurrency()
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

    // Convert Currency
    private func convertingCurrency() {
        let amountToConvert = Double(amountTextField.text!)!
        let chosenCurrency = deviseLabel.text!
        
        // First, convert chosenCurrency to EUR
        let convertedToEUR = amountToConvert / Currency.shared.rates![chosenCurrency]!
        // Then convert EUR to USD and String
        var result = convertedToEUR * Currency.shared.rates!["USD"]!
        
        // Round it to 2 digits after the . max
        result = Double(round(100*result)/100)
        
        // Update the label with the result
        self.convertedAmountLabel.text = String(result)
    }
}

// Keyboard management
extension CurrencyViewController: UITextFieldDelegate {

    // When tapping inside the UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Animations of headerView, scrollView and converterButton
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 92)
            self.headerView.alpha = 0
            self.converterButton.transform = CGAffineTransform(translationX: 0, y: 92)
            self.loader.transform = CGAffineTransform(translationX: 0, y: 92)
            self.amountTextField.alpha = 1
            self.amountTextField.placeholder = ""
        }

        // Add gesture for dismiss the keyboard when tapping outside the UITextField
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
        self.view.addGestureRecognizer(tap)

        return true
    }

    // Limit the number of characters in the textField
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = amountTextField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= 7
    }

    // When tapping the return key of the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Check if the text is a valid double
        guard checkForValidDouble() else { return false }

        // Hide the keyboard
        textField.resignFirstResponder()
        // Animations of headerView, scrollView and converterButton
        resetUI()
        // Convert currency
        convertCurrency()
        return true
    }

    // Dismiss the keyboard when tap on screen
    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        // Check if the text is empty
        guard amountTextField.text!.isEmpty == false else {
            amountTextField.resignFirstResponder()
            resetUI()
            setTextFieldStyle()
            convertedAmountLabel.text = "0"
            return
        }

        // Check for a valid number
        guard checkForValidDouble() else { return }

        amountTextField.resignFirstResponder()
        resetUI()
    }

    // Regex for valid double
    private func checkForValidDouble() -> Bool {
        // Check if the text is a valid double
        guard let text = amountTextField.text else { return false }
        guard text.range(of: "^(([1-9]\\d*)|(0))(((\\.)|(\\,))\\d{1,2})?$",
                         options: .regularExpression) != nil else {
            alertForWrongNumber()
            return false
        }
        // replace , by a .
        let replaced = text.replacingOccurrences(of: ",", with: ".")
        self.amountTextField.text = replaced
        return true
    }

    // Replacing the UI elements from origin
    private func resetUI() {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.headerView.alpha = 1
            self.converterButton.transform = .identity
            self.loader.transform = .identity
        }

        // Button converter is active or not
        if amountTextField.text!.isEmpty {
            converterButton.isEnabled = false
        } else {
            converterButton.isEnabled = true
        }
    }

    // Reset the style of AmountTextField placeholder
    private func setTextFieldStyle() {
        // Set the placeholder
        amountTextField.attributedPlaceholder =
            NSAttributedString(string: "Tapez ici",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // Set the textfield opacity
        amountTextField.alpha = 0.3
    }
}

// Protocol
extension CurrencyViewController: IsAbleToReceiveData {
    // Recieve Data from another VC
    func pass(_ data: String) {
        deviseLabel.text! = data
        // Then convert again if the text is not empty
        guard amountTextField.text!.isEmpty else {
           convertingCurrency()
            return
        }
    }
}

// Alerts
extension CurrencyViewController {
    // Alert for wrong number
    private func alertForWrongNumber() {
        let alertVC = UIAlertController(title: "Oups!",
                                        message: "Veuillez entrer un chiffre correct.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }

    // Alert for API fail
    private func alertCurrencyFail() {
        let alertVC = UIAlertController(title: "Erreur réseau",
                                        message: "Vérifiez votre réseau et ressayez.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
}
