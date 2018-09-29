//
//  InfoPatientView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/22/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display info of a patient
class InfoPatientView: BaseUIView {
    
    private var patient = HISMartManager.share.currentPatient
    
    var address: String? {
        didSet {
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal(
                    "Địa chỉ: ",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize,
                    weight: UIFont.Weight.medium
                ).normal(
                    self.patient.address?.getDescription() ?? "",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize
            )
            
            self.addressLabel.attributedText = formattedString
        }
    }
    
    // MARK: Define controls
    private lazy var genderLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        let gender: String = self.patient.sex_ID.toString()
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Giới tính: ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                weight: UIFont.Weight.medium
            ).normal(
                gender,
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    private lazy var dateOfBirthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Ngày sinh: ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                weight: UIFont.Weight.medium
            ).normal(
                self.patient.birth_Date.getDescription_DDMMYYYY_WithSlash(),
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Tuổi: ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                weight: UIFont.Weight.medium
            ).normal(
                self.patient.birth_Date.getOld().description,
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Sđt: ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                weight: UIFont.Weight.medium
            ).normal(
                self.patient.mobile_Phone,
                textColor: Theme.shared.primaryColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Địa chỉ: ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                weight: UIFont.Weight.medium
            ).normal(
                self.patient.address?.getDescription() ?? "",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    // MARK: Setup layout
    override func setupView() {
        self.backgroundColor = Theme.shared.darkBGColor
        self.setupGenderLabel()
        self.setupDateOfBirthLabel()
        self.setupAgeLabel()
        self.setupPhoneNumberLabel()
        self.setupAddressLabel()
    }
    
    private func setupGenderLabel() {
        self.addSubview(self.genderLabel)
        self.genderLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupDateOfBirthLabel() {
        self.addSubview(self.dateOfBirthLabel)
        self.dateOfBirthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.genderLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.genderLabel)
        }
    }
    
    private func setupAgeLabel() {
        self.addSubview(self.ageLabel)
        self.ageLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.dateOfBirthLabel)
            make.centerX.equalToSuperview().multipliedBy(3.0/2.0)
        }
    }
    
    private func setupPhoneNumberLabel() {
        self.addSubview(self.phoneNumberLabel)
        self.phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateOfBirthLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.right.equalTo(self.genderLabel)
        }
    }
    
    private func setupAddressLabel() {
        self.addSubview(self.addressLabel)
        self.addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneNumberLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.right.equalTo(self.phoneNumberLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
}
