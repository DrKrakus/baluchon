//
//  TranslatorViewController.swift
//  Baluchon
//
//  Created by Jerome Krakus on 12/02/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController {

    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var translatorButton: DesignableButton!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var targetTextView: UITextView!
    @IBOutlet weak var separatorView: UIImageView!
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var sourceTextView: UITextView!

    // MARK: Action
    @IBAction func didTapTranslatorButton(_ sender: Any) {
        getTranslation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the translate.quote
        Translate.shared.quote = sourceTextView.text
        targetTextView.text = Translate.shared.translatedQuote

        // Set placeholders and tint color
        setPlaceholders()
        sourceTextView.tintColor = .white
    }

    // Translate func
    private func getTranslation() {
        TranslateService.shared.getTranslation { (success, response) in
            if success {
                self.targetTextView.text = response!
            } else {
                self.alertTranslationFail()
            }
        }
    }
}

extension TranslatorViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // Animations of headerView, scrollView and converterButton
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 200)
            self.translatorButton.transform = CGAffineTransform(translationX: 0, y: 200)
            self.headerView.alpha = 0
            self.topView.alpha = 0
            self.separatorView.alpha = 0
        }

        // Add gesture for dismiss the keyboard when tapping outside the UITextField
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:)))
        self.view.addGestureRecognizer(tap)

        if sourceTextView.text == "Tapez ici" {
            sourceTextView.alpha = 1
            sourceTextView.text = ""
        }

        return true
    }

    // When the return key is taped
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if sourceTextView.text == "" {
                textView.resignFirstResponder()
                resetUI()
                setPlaceholders()
                targetTextView.text = ""
            } else {
                textView.resignFirstResponder()
                resetUI()
                Translate.shared.quote = textView.text
                getTranslation()
            }
            return false
        }
        return true
    }

    @objc private func hideKeyboard(_ gesture: UITapGestureRecognizer) {

        sourceTextView.resignFirstResponder()
        resetUI()

        if sourceTextView.text == "" {
            setPlaceholders()
            targetTextView.text = ""
        } else {
            Translate.shared.quote = sourceTextView.text
            getTranslation()
        }
    }

    private func resetUI() {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.translatorButton.transform = .identity
            self.headerView.alpha = 1
            self.topView.alpha = 1
            self.separatorView.alpha = 1
        }
    }

    private func setPlaceholders() {
        // Set the placeholder
        sourceTextView.text = "Tapez ici"
        // Set the textfield opacity
        sourceTextView.alpha = 0.3
    }
}

// Alerts
extension TranslatorViewController {
    // Alert for API fail
    private func alertTranslationFail() {
        let alertVC = UIAlertController(title: "Erreur réseau",
                                        message: "Vérifiez votre réseau et ressayez.",
                                        preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true)
    }
}
