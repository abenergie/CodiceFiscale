//
//  ViewController.swift
//  CodiceFiscale
//
//  Created by mo3bius on 05/21/2019.
//  Copyright (c) 2019 mo3bius. All rights reserved.
//

import UIKit
import CodiceFiscale

class FiscalCodeViewController: BaseViewController {

    // MARK: - Outlets
    // Views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var genederSegmentedControl: UISegmentedControl!

    // Labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!

    // Text Fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var cityOfBirthTextField: UITextField!
    @IBOutlet weak var fiscalCodeTextField: UITextField!

    // Buttons
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!

    // MARK: - Components
    let datePicker = UIDatePicker()

    // MARK: - Objects
    private let fiscalCodeManager = FiscalCodeManager()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupDataPicker()
        configurationText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollView.contentSize = stackView.frame.size
    }

    // MARK: - Setup
    private func setup() {
        nameTextField.delegate = self
        surnameTextField.delegate = self
        dateOfBirthTextField.delegate = self
        cityOfBirthTextField.delegate = self
    }

    private func setupDataPicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handlePicker(_:)), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
    }

    // MARK: - Configurations
    private func configurationText() {
        titleLabel.text = "Codice Fiscale"
        nameTextField.placeholder = "Nome"
        surnameTextField.placeholder = "Cognome"
        dateOfBirthTextField.placeholder = "Data di nascita"
        genderLabel.text = "Sesso"
        cityOfBirthTextField.placeholder = "Città di nascita"
        fiscalCodeTextField.placeholder = "Codice fiscale"
    }

    // MARK: - Helpers
    private func checkField(_ textField: UITextField) -> String? {
        guard let value = textField.text, !value.isEmpty else {
            return nil
        }

        return value
    }

    @objc private func handlePicker(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        dateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
    }

    private func fillFields(fiscalCode: String, data: FiscalCode?) {
        guard let data = data else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"

        nameTextField.text = data.name
        surnameTextField.text = data.surname
        dateOfBirthTextField.text = dateFormatter.string(from: data.date)
        genederSegmentedControl.selectedSegmentIndex = data.gender == .male ? 0 : 1
        cityOfBirthTextField.text = data.town
        fiscalCodeTextField.text = fiscalCode
    }

    // MARK: - Actions
    @IBAction func calculateDidTap(_ sender: Any) {
        guard
            let name = checkField(nameTextField),
            let surname = checkField(surnameTextField),
            let dateString = checkField(dateOfBirthTextField),
            let date = Date.from(string: dateString, withFormat: "dd MMM yyyy"),
            let city = checkField(cityOfBirthTextField),
            genederSegmentedControl.selectedSegmentIndex != -1
        else {
            return
        }

        let data = FiscalCode(name: name,
                              surname: surname,
                              gender: genederSegmentedControl.selectedSegmentIndex == 0 ? .male : .female,
                              date: date,
                              town: city,
                              province: city)

        let fiscalCode = fiscalCodeManager.calculate(fiscalCodeData: data)
        fiscalCodeTextField.text = fiscalCode
    }

    @IBAction func reverseDidTap(_ sender: Any) {
        guard
            let fiscalCode = checkField(fiscalCodeTextField),
            let object = fiscalCodeManager.retriveInformationFrom(fiscalCode: fiscalCode)
        else {
            return
        }

        fillFields(fiscalCode: fiscalCode, data: object)
    }

    @IBAction func scanDidTap(_ sender: Any) {
        let scannerVC = fiscalCodeManager.scanFiscalCode { (fiscalCode, data) in
            self.fillFields(fiscalCode: fiscalCode, data: data)
        }

        self.present(scannerVC, animated: true, completion: nil)
    }
}
