//
//  HeaderPatientInfoView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/22/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class HeaderPatientInfoView: BaseUIView {
    
    private let patient = HISMartManager.share.currentPatient
    
    var mainDoctor: User? {
        didSet {
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal(
                    "Bs theo dõi chính: ",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize,
                    weight: UIFont.Weight.medium
                ).normal(
                    self.mainDoctor?.fullName ?? "",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize
            )
            self.mainDoctorNameLabel.attributedText = formattedString
        }
    }
    
    var users = [User]() {
        didSet {
            var titles: String = ""
            titles += self.users.enumerated().flatMap({ (index, user) -> String in
                if index != self.users.count - 1 {
                    return "BS." + user.fullName + ", "
                } else {
                    return "BS." + user.fullName
                }
            })
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal(
                    "Bs theo dõi phụ: ",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize,
                    weight: UIFont.Weight.medium
                ).normal(
                    titles,
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize
            )
            
            self.followDoctorNameLabel.attributedText = formattedString
        }
    }
    
    // MARK: Define controls
    private lazy var patientNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = self.patient.patient_Name
        return label
    }()
    
    private lazy var patienIDLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = self.patient.patient_ID
        return label
    }()
    
    private let healthFacilitiesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.textAlignment = .right
        label.text = ""
        return label
    }()
    
    private let mainDoctorNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let followDoctorNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Setup layout
    override func setupView() {
        self.backgroundColor = Theme.shared.darkBGColor
        self.setupPatientNameLabel()
        self.setupPatienIDLabel()
        self.setupHealthFacilitiesLabel()
        self.setupMainDoctorNameLabel()
        self.setupFollowDoctorNameLabel()
    }
    
    private func setupPatientNameLabel() {
        self.addSubview(self.patientNameLabel)
        self.patientNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupPatienIDLabel() {
        self.addSubview(self.patienIDLabel)
        self.patienIDLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientNameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.patientNameLabel)
        }
    }
    
    private func setupHealthFacilitiesLabel() {
        self.addSubview(self.healthFacilitiesLabel)
        self.healthFacilitiesLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.patienIDLabel)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupMainDoctorNameLabel() {
        self.addSubview(self.mainDoctorNameLabel)
        self.mainDoctorNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.patienIDLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(self.patientNameLabel)
        }
    }
    
    private func setupFollowDoctorNameLabel() {
        self.addSubview(self.followDoctorNameLabel)
        self.followDoctorNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.mainDoctorNameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(self.patientNameLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
}




