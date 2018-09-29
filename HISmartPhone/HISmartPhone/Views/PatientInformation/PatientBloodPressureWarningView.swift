//
//  PatientBloodPressureWarningView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/23/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

protocol PatientBloodPressureWarningDelegate: class {
    func editingPatientBloodPressure()
}

// This class display
class PatientBloodPressureWarningView: BaseUIView {
    
    var patient = Patient() {
        didSet {
            self.lowSystolicValueLabel.text = self.patient.lowSystolic.description
            self.lowDiastolicValueLabel.text = self.patient.lowDiastolic.description
            self.preHighSystolicValueLabel.text = self.patient.preHighSystolic.description
            self.preHighDiastolicValueLabel.text = self.patient.preHighDiastolic.description
            self.highSystolicValueLabel.text = self.patient.highSystolic.description
            self.highDiastolicValueLabel.text = self.patient.highDiastolic.description
        }
    }
    
    // MARK: Define variable
    var delegate: PatientBloodPressureWarningDelegate?
    
    // MARK: Define controls
    private let editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "mode_edit_blue"), for: .normal)
        return button
    }()
    
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
    
    private let lowSystolicValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        return label
    }()
    
    private let preHighSystolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "PreHighSystolic"
        return label
    }()
    
    private let preHighSystolicValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        return label
    }()
    
    private let highSystolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "HighSystolic"
        return label
    }()
    
    private let highSystolicValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0

        return label
    }()
    
    private let lowDiastolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "LowDiastolic"
        return label
    }()
    
    private let lowDiastolicValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0

        return label
    }()
    
    private let preHighDiastolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "PreHighDiastolic"
        return label
    }()
    
    private let preHighDiastolicValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        return label
    }()
    
    private let highDiastolicLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "HighDiastolic"
        return label
    }()
    
    private let highDiastolicValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Setup layout
    override func setupView() {
        self.backgroundColor = Theme.shared.darkBGColor
        self.setupTitleLabel()
        self.setupEditButton()
        self.setupLowSystolicLabel()
        self.setupLowSystolicValueLabel()
        self.setupPreHighSystolicLabel()
        self.setupPreHighSystolicValueLabel()
        self.setupHighSystolicLabel()
        self.setupHighSystolicValueLabel()
        self.setupLowDiastolicLabel()
        self.setupLowDiastolicValueLabel()
        self.setupPreHighDiastolicLabel()
        self.setupPreHighDiastolicValueLabel()
        self.setupHighDiastolicLabel()
        self.setupHighDiastolicValueLabel()
        
        if Authentication.share.typeUser == .doctor {
            self.editButton.isHidden = false
        } else {
            self.editButton.isHidden = true
        }
        
    }
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_32)
        }
    }
    
    private func setupEditButton() {
        self.addSubview(self.editButton)
        self.editButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
        
        self.editButton.addTarget(
            self,
            action: #selector(PatientBloodPressureWarningView.handleEditButton),
            for: .touchUpInside
        )
    }
    
    private func setupLowSystolicLabel() {
        self.addSubview(self.lowSystolicLabel)
        self.lowSystolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.titleLabel)
        }
    }
    
    private func setupLowSystolicValueLabel() {
        self.addSubview(self.lowSystolicValueLabel)
        self.lowSystolicValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.lowSystolicLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.lowSystolicLabel)
        }
    }
    
    private func setupPreHighSystolicLabel() {
        self.addSubview(self.preHighSystolicLabel)
        self.preHighSystolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.lowSystolicValueLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.lowSystolicValueLabel)
        }
        
    }
    
    private func setupPreHighSystolicValueLabel() {
        self.addSubview(self.preHighSystolicValueLabel)
        self.preHighSystolicValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.preHighSystolicLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.preHighSystolicLabel)
        }
    }
    
    private func setupHighSystolicLabel() {
        self.addSubview(self.highSystolicLabel)
        self.highSystolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.preHighSystolicValueLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.preHighSystolicValueLabel)
        }
    }
    
    private func setupHighSystolicValueLabel() {
        self.addSubview(self.highSystolicValueLabel)
        self.highSystolicValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.highSystolicLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.highSystolicLabel)
        }
    }
    
    private func setupLowDiastolicLabel() {
        self.addSubview(self.lowDiastolicLabel)
        self.lowDiastolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.lowSystolicLabel)
            make.left.equalTo(self.snp.centerX).offset(Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupLowDiastolicValueLabel() {
        self.addSubview(self.lowDiastolicValueLabel)
        self.lowDiastolicValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.lowSystolicValueLabel)
            make.left.equalTo(self.lowDiastolicLabel)
        }
    }
    
    private func setupPreHighDiastolicLabel() {
        self.addSubview(self.preHighDiastolicLabel)
        self.preHighDiastolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.preHighSystolicLabel)
            make.left.equalTo(self.lowDiastolicValueLabel)
        }
    }
    
    private func setupPreHighDiastolicValueLabel() {
        self.addSubview(self.preHighDiastolicValueLabel)
        self.preHighDiastolicValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.preHighSystolicValueLabel)
            make.left.equalTo(self.preHighDiastolicLabel)
        }
    }
    
    private func setupHighDiastolicLabel() {
        self.addSubview(self.highDiastolicLabel)
        self.highDiastolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.highSystolicLabel)
            make.left.equalTo(self.preHighDiastolicValueLabel)
        }
    }
    
    private func setupHighDiastolicValueLabel() {
        self.addSubview(self.highDiastolicValueLabel)
        self.highDiastolicValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.highSystolicValueLabel)
            make.left.equalTo(self.highDiastolicLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    // MARK: Handle action
    @objc private func handleEditButton() {
        self.delegate?.editingPatientBloodPressure()
    }
}
