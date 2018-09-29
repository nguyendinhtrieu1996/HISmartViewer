//
//  PatientInfoView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class PatientInfoView: BaseUIView {
    
    // MARK: Define controls
    private let patientName: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Nguyễn Văn A"
        return label
    }()
    
    private let patientID: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "A4325436"
        return label
    }()
    
    private let patientGender: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Nam"
        return label
        
    }()
    
    private let patientDateOfBirth: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Ngày sinh: 04/15/1967"
        return label
    }()
    
    private let patientBloodGroup: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Nhóm máu: O"
        return label
    }()
    
    private let patientBloodPressure: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Huyết áp: 345/43"
        return label
    }()
    
    private let statisticType: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.hightStatisticColor
        label.numberOfLines = 0
        label.text = "PreHighSystolic"
        return label
    }()
    
    private let medicalDeviceID: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Mã số thiết bị y tế: 4365473"
        return label
    }()
    
    
    // MARK: Setup UI
    override func setupView() {
        self.setupPatientName()
        self.setupPatientID()
        self.setupPatientGender()
        self.setupPatientDateOfBirth()
        self.setupPatientBloodGroup()
        self.setupPatientBloodPressure()
        self.setupStatisticType()
        self.setupMedicalDeviceID()
    }
    
    private func setupPatientName() {
        self.addSubview(self.patientName)
        self.patientName.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
    }
    
    private func setupPatientID() {
        self.addSubview(self.patientID)
        self.patientID.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientName.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.patientName)
        }
    }
    
    private func setupPatientGender() {
        self.addSubview(self.patientGender)
        self.patientGender.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.patientID)
            make.left.equalTo(self.snp.centerX)
            make.right.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupPatientDateOfBirth() {
        self.addSubview(self.patientDateOfBirth)
        self.patientDateOfBirth.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientID.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(self.patientName)
        }
    }
    
    private func setupPatientBloodGroup() {
        self.addSubview(self.patientBloodGroup)
        self.patientBloodGroup.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientDateOfBirth.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(self.patientDateOfBirth)
        }
    }
    
    private func setupPatientBloodPressure() {
        self.addSubview(self.patientBloodPressure)
        self.patientBloodPressure.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientBloodGroup.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.patientBloodGroup)
        }
    }
    
    private func setupStatisticType() {
        self.addSubview(self.statisticType)
        self.statisticType.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientBloodPressure)
            make.left.right.equalTo(self.patientGender)
        }
    }
    
    private func setupMedicalDeviceID() {
        self.addSubview(self.medicalDeviceID)
        self.medicalDeviceID.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientBloodPressure.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(self.patientBloodGroup)
            make.bottom.equalToSuperview()
        }
    }
    
    func setValue(patient: Patient) {
        self.patientName.text = patient.patient_Name
        self.patientID.text = patient.PID_ID
        self.patientGender.text = patient.sex_ID.toString()
        self.patientDateOfBirth.text = "Ngày sinh: \(patient.birth_Date.getDescription_DDMMYYYY_WithSlash())"
        self.patientBloodGroup.text = "Nhóm máu: \(patient.bloodType)"
        self.patientBloodPressure.text = "Huyết áp: \(patient.preHighSystolic)/\(patient.preHighDiastolic)"
        self.medicalDeviceID.text = "Mã số thiết bị y tế: \(patient.TBPM_ID)"
    }
}





