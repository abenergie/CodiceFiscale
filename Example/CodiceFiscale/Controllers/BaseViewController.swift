//
//  BaseViewController.swift
//  CodiceFiscale_Example
//
//  Created by Luigi Aiello on 21/05/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Setup
    private func setup() {
        // Click to dissmiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissKeboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Helpers
    @objc private func dissmissKeboard(_ sender: UITapGestureRecognizer) {
        view.dissmissKeyboard()
    }
}

// MARK: - Text View Delegate
extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let topView = view.window?.subviews.first else {
            return false
        }

        if let nextField = topView.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }
}
