//
//  ListPatientCell.swift
//  HISmartPhone
//
//  Created by MACOS on 12/21/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ListPatientCell: BaseTableViewCell {
    
    var index: Int = 0 {
        didSet {
            self.orderNumberLabel.text = index.description
        }
    }
    
    var patient: Patient? {
        didSet {
            self.patientCodeLabel.text = self.patient?.patient_ID
            self.nameLabel.text = self.patient?.patient_Name
            self.DOBLabel.text = self.patient?.birth_Date.getDescription_DDMMYYYY()
            self.phoneNumberLabel.text = self.patient?.mobile_Phone
            
            let alarmStatus = self.patient?.alarmStatus ?? .null
            
            switch alarmStatus {
            case .null:
                self.circleView.backgroundColor = Theme.shared.normalStatisticColor
                break
            case .low:
                self.circleView.backgroundColor = Theme.shared.lowStatisticColor
                break
            case .normal:
                self.circleView.backgroundColor = Theme.shared.normalStatisticColor
                break
            case .preHigh:
                self.circleView.backgroundColor = Theme.shared.hightStatisticColor
                break
            case .high:
                self.circleView.backgroundColor = Theme.shared.veryHightStatisticColor
                break
            }
        }
    }
    
    //MARK: UIControl
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let patientCodeLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let DOBLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let circleView: UIView = {
        let viewConfig = UIView()
        
        viewConfig.backgroundColor = Theme.shared.heartRateChartColor
        viewConfig.layer.cornerRadius = Dimension.shared.widthStatusCircle / 2
        viewConfig.layer.masksToBounds = true
        
        return viewConfig
    }()
    
    private let lineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lightBlueLineDivider
        return viewConfig
    }()
    
    //MARK: Initialize function
    override func setupView() {
        self.setupViewOderNumber()
        self.setupViewPatientcodeLabel()
        self.setupViewNameLabel()
        self.setupViewDOBLabel()
        self.setupViewPhoneLabel()
        self.setupViewStatusCircle()
        self.setupViewLineDivider()
    }
    
    //MARK: SetupView function
    private func setupViewOderNumber() {
        self.addSubview(self.orderNumberLabel)
        
        if #available(iOS 11, *) {
            self.orderNumberLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
                make.left.equalTo(self.safeAreaLayoutGuide).offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.orderNumberLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
                make.left.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            }
        }
        
    }
    
    private func setupViewPatientcodeLabel() {
        self.addSubview(self.patientCodeLabel)
        
        
        if #available(iOS 11, *) {
            self.patientCodeLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.orderNumberLabel)
                make.left.equalTo(self.safeAreaLayoutGuide).offset(77 * Dimension.shared.widthScale)
            }
        } else {
            self.patientCodeLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.orderNumberLabel)
                make.left.equalToSuperview().offset(77 * Dimension.shared.widthScale)
            }
        }
    }
    
    private func setupViewNameLabel() {
        self.addSubview(self.nameLabel)
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientCodeLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            make.left.equalTo(self.patientCodeLabel)
        }
    }
    
    private func setupViewDOBLabel() {
        self.addSubview(self.DOBLabel)
        
        self.DOBLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            make.left.equalTo(self.nameLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewPhoneLabel() {
        self.addSubview(self.phoneNumberLabel)
        
        if #available(iOS 11, *) {
            self.phoneNumberLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.orderNumberLabel)
                make.right.equalTo(self.safeAreaLayoutGuide).offset(-Dimension.shared.mediumHorizontalMargin)
            }
        } else {
            self.phoneNumberLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.orderNumberLabel)
                make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            }
        }
    }
    
    private func setupViewStatusCircle() {
        self.addSubview(self.circleView)
        
        self.circleView.snp.makeConstraints { (make) in
            make.width.height.equalTo(Dimension.shared.widthStatusCircle)
            make.right.equalTo(self.phoneNumberLabel)
            make.top.equalTo(self.phoneNumberLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewLineDivider() {
        self.addSubview(self.lineDivider)
        
        self.lineDivider.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-Dimension.shared.smallHorizontalMargin)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
    
}





