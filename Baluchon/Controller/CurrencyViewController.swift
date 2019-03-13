//
//  CurrencyViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit
import Foundation

class CurrencyViewController: UIViewController, UITextFieldDelegate {

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

        // Create and add the gesture for deviseButton
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showCurrencies(_:)))
        deviseButton.addGestureRecognizer(tap)
    }

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

    // When tapping the return key of the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Check if the text is a valid double
        guard checkForValidDouble() else { return false }

        // Hide the keyboard
        textField.resignFirstResponder()
        // Animations of headerView, scrollView and converterButton
        resetUI()

        return true
    }

    // Show currencies
    @objc func showCurrencies(_ gesture: UIGestureRecognizer) {
    }

    // Dismiss the keyboard when tap on screen
    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        // Check if the text is empty
        guard amountTextField.text!.isEmpty == false else {
            amountTextField.resignFirstResponder()
            resetUI()
            setTextFieldStyle()
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
        guard text.range(of: "^(([1-9]\\d*)|(0))(\\.\\d{1,2})?$", options: .regularExpression) != nil else {
            alertForWrongNumber()
            return false
        }

        return true
    }

    // Alert for wrong number
    private func alertForWrongNumber() {
        let alertVC = UIAlertController(title: "Oups!",
                                        message: "Veuillez entrer un chiffre correct (ex: 9.50)",
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

    // Replacing the UI elements from origin
    private func resetUI() {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.headerView.alpha = 1
            self.converterButton.transform = .identity
        }

        // Button converter is active or not
        if amountTextField.text!.isEmpty {
            converterButton.isEnabled = false
        } else {
            converterButton.isEnabled = true
        }
    }

    private func setTextFieldStyle() {
        // Set the placeholder
        amountTextField.attributedPlaceholder =
            NSAttributedString(string: "Tapez ici",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        // Set the textfield opacity
        amountTextField.alpha = 0.3
    }

    private func convertCurrency() {
        // Hiding the button and show the loader
        converterButton.isHidden = true
        loader.isHidden = false

        CurrencyService.shared.getCurrency { (success, currency) in
            // Showing the button and hide the loader
            self.converterButton.isHidden = false
            self.loader.isHidden = true

            if success, let currency = currency {
                let amountToConvert = Double(self.amountTextField.text!)!
                let chosenCurrency = self.deviseLabel.text!

                // First, convert chosenCurrency to EUR
                let convertedToEUR = amountToConvert / currency.rates[chosenCurrency]!
                // Then convert EUR to USD
                let result = convertedToEUR * currency.rates["USD"]!

                // Update the label with the result
                self.convertedAmountLabel.text = String(result)
            } else {
                self.alertCurrencyFail()
            }
        }
    }
}
