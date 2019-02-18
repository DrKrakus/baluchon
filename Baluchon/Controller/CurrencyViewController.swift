//
//  CurrencyViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var converterButton: DesignableButton!

    // MARK: Action
    @IBAction func didTapConverterButton(_ sender: Any) {
    }

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Asign the UITextFieldDelegate to amountTextField
        amountTextField.delegate = self
    }

    // When tapping inside the UITextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Animations of headerView, scrollView and converterButton
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 92)
            self.headerView.alpha = 0
            self.converterButton.transform = CGAffineTransform(translationX: 0, y: 92)
        }

        // Add gesture for dismiss the keyboard when tapping outside the UITextField
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard (_:)))
        self.view.addGestureRecognizer(tap)

        return true
    }

    // When tapping the return key of the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        // Animations of headerView, scrollView and converterButton
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.headerView.alpha = 1
            self.converterButton.transform = .identity
        }
        return true
    }

    // Dismiss the keyboard
    @objc func hideKeyboard (_ gesture: UITapGestureRecognizer) {
        // Hide the keyboard
        amountTextField.resignFirstResponder()

        // Animations of headerView, scrollView and converterButton
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.headerView.alpha = 1
            self.converterButton.transform = .identity
        }
    }
}
