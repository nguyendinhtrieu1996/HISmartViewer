//
//  EditPatientBloodPressureWarningView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display
class EditPatientBloodPressureWarningView: BaseUIView {
    
    // MARK: Define controls
    var patient: Patient? {
        didSet {
            guard let patient = self.patient else { return }
            
            self.setValue(patient: patient)
            
            self.systolic.setValue(
                low: patient.lowSystolic,
                preHigh: patient.preHighSystolic,
                high: patient.highSystolic
            )
            
            self.diastolic.setValue(
                low: patient.lowDiastolic,
                preHigh: patient.preHighDiastolic,
                high: patient.highDiastolic
            )
        }
    }
    
    private (set) var systolic: BloodPressure = BloodPressure(low: 0, preHigh: 0, high: 0)
    private (set) var diastolic: BloodPressure = BloodPressure(low: 0, preHigh: 0, high: 0)
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.accentColor
        label.numberOfLines = 0
        label.text = "Thông số ngưỡng cảnh báo huyết áp"
        return label
    }()
    
    private let lowSystolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "LowSystolic"
        return label
    }()
    
    fileprivate let lowSystolicValueTextField: CustomTextField = CustomTextField(
        placeholder: "",
        fontSize: Dimension.shared.captionFontSize,
        keyboardType: .numberPad
    )
    
    private let preHighSystolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "PreHighSystolic"
        return label
    }()
    
    fileprivate let preHighSystolicValueTextField: CustomTextField = CustomTextField(
        placeholder: "",
        fontSize: Dimension.shared.captionFontSize,
        keyboardType: .numberPad
    )
    
    private let highSystolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "HighSystolic"
        return label
    }()
    
    fileprivate let highSystolicValueTextField: CustomTextField = CustomTextField(
        placeholder: "",
        fontSize: Dimension.shared.captionFontSize,
        keyboardType: .numberPad
    )
    
    private let lowDiastolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "LowDiastolic"
        return label
    }()
    
    fileprivate let lowDiastolicValueTextField: CustomTextField = CustomTextField(
        placeholder: "",
        fontSize: Dimension.shared.captionFontSize,
        keyboardType: .numberPad
    )
    
    private let preHighDiastolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "PreHighDiastolic"
        return label
    }()
    
    fileprivate let preHighDiastolicValueTextField: CustomTextField = CustomTextField(
        placeholder: "",
        fontSize: Dimension.shared.captionFontSize,
        keyboardType: .numberPad
    )
    
    private let highDiastolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "HighDiastolic"
        return label
    }()
    
    fileprivate let highDiastolicValueTextField: CustomTextField = CustomTextField(
        placeholder: "",
        fontSize: Dimension.shared.captionFontSize,
        keyboardType: .numberPad
    )
    
    // MARK: Setup layout
    override func setupView() {
        self.backgroundColor = Theme.shared.darkBGColor
        self.setupTitleLabel()
        self.setupLowSystolicLabel()
        self.setupLowSystolicValueTextField()
        self.setupPreHighSystolicLabel()
        self.setupPreHighSystolicValueTextField()
        self.setupHighSystolicLabel()
        self.setupHighSystolicValueTextField()
        self.setupLowDiastolicLabel()
        self.setupLowDiastolicValueTextField()
        self.setupPreHighDiastolicLabel()
        self.setupPreHighDiastolicValueTextField()
        self.setupHighDiastolicLabel()
        self.setupHighDiastolicValueTextField()
    }
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
        }
    }
    
    private func setupLowSystolicLabel() {
        self.addSubview(self.lowSystolicLabel)
        self.lowSystolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.titleLabel)
        }
    }
    
    private func setupLowSystolicValueTextField() {
        self.addSubview(self.lowSystolicValueTextField)
        self.lowSystolicValueTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.lowSystolicLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.lowSystolicLabel)
            make.right.equalTo(self.snp.centerX).offset(-Dimension.shared.mediumHorizontalMargin)
        }
        self.lowSystolicValueTextField.delegate = self
    }
    
    private func setupPreHighSystolicLabel() {
        self.addSubview(self.preHighSystolicLabel)
        self.preHighSystolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.lowSystolicValueTextField.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.lowSystolicValueTextField)
        }
        
    }
    
    private func setupPreHighSystolicValueTextField() {
        self.addSubview(self.preHighSystolicValueTextField)
        self.preHighSystolicValueTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.preHighSystolicLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.preHighSystolicLabel)
            make.right.equalTo(self.lowSystolicValueTextField)
        }
        self.preHighSystolicValueTextField.delegate = self
    }
    
    private func setupHighSystolicLabel() {
        self.addSubview(self.highSystolicLabel)
        self.highSystolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.preHighSystolicValueTextField.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.preHighSystolicValueTextField)
        }
    }
    
    private func setupHighSystolicValueTextField() {
        self.addSubview(self.highSystolicValueTextField)
        self.highSystolicValueTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.highSystolicLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.highSystolicLabel)
            make.right.equalTo(self.preHighSystolicValueTextField)
        }
        self.highSystolicValueTextField.delegate = self
    }
    
    private func setupLowDiastolicLabel() {
        self.addSubview(self.lowDiastolicLabel)
        self.lowDiastolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.lowSystolicLabel)
            make.left.equalTo(self.snp.centerX).offset(Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupLowDiastolicValueTextField() {
        self.addSubview(self.lowDiastolicValueTextField)
        self.lowDiastolicValueTextField.snp.makeConstraints { (make) in
            make.top.width.equalTo(self.lowSystolicValueTextField)
            make.left.equalTo(self.lowDiastolicLabel)
        }
        self.lowDiastolicValueTextField.delegate = self
    }
    
    private func setupPreHighDiastolicLabel() {
        self.addSubview(self.preHighDiastolicLabel)
        self.preHighDiastolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.preHighSystolicLabel)
            make.left.equalTo(self.lowDiastolicValueTextField)
        }
    }
    
    private func setupPreHighDiastolicValueTextField() {
        self.addSubview(self.preHighDiastolicValueTextField)
        self.preHighDiastolicValueTextField.snp.makeConstraints { (make) in
            make.top.width.equalTo(self.preHighSystolicValueTextField)
            make.left.equalTo(self.preHighDiastolicLabel)
        }
        self.preHighDiastolicValueTextField.delegate = self
    }
    
    private func setupHighDiastolicLabel() {
        self.addSubview(self.highDiastolicLabel)
        self.highDiastolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.highSystolicLabel)
            make.left.equalTo(self.preHighDiastolicValueTextField)
        }
    }
    
    private func setupHighDiastolicValueTextField() {
        self.addSubview(self.highDiastolicValueTextField)
        self.highDiastolicValueTextField.snp.makeConstraints { (make) in
            make.top.width.equalTo(self.highSystolicValueTextField)
            make.left.equalTo(self.highDiastolicLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
        self.highDiastolicValueTextField.delegate = self
    }
    
    func setValue(patient: Patient) {
        self.lowSystolicValueTextField.setValue(text: patient.lowSystolic.description)
        self.preHighSystolicValueTextField.setValue(text: patient.preHighSystolic.description)
        self.highSystolicValueTextField.setValue(text: patient.highSystolic.description)
        self.lowDiastolicValueTextField.setValue(text: patient.lowDiastolic.description)
        self.preHighDiastolicValueTextField.setValue(text: patient.preHighDiastolic.description)
        self.highDiastolicValueTextField.setValue(text: patient.highDiastolic.description)
    }
}

// MARK: Extension
extension EditPatientBloodPressureWarningView: CustomTextFieldDelegate {
    func editingBegin(customTextField: CustomTextField) {}
    
    func editingDidEnd(customTextField: CustomTextField) {}
    
    func editingChanged(customTextField: CustomTextField, text: String?) {
        guard let text = text else { return }
        
        customTextField.textField.text = Int(text)?.description ??  "0"
        
        switch customTextField {
        case self.lowSystolicValueTextField:
            self.systolic.low = Int(text) ?? 0
            break
        case self.preHighSystolicValueTextField:
            self.systolic.preHigh = Int(text) ?? 0
            break
        case self.highSystolicValueTextField:
            self.systolic.high = Int(text) ?? 0
            break
        case self.lowDiastolicValueTextField:
            self.diastolic.low = Int(text) ?? 0
            break
        case self.preHighDiastolicValueTextField:
            self.diastolic.preHigh = Int(text) ?? 0
            break
        case self.highDiastolicValueTextField:
            self.diastolic.high = Int(text) ?? 0
            break
        default:
            break
        }
    }
}
