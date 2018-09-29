//
//  PatientMedicalInfoView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/22/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display blood group and medical device Id
class PatientMedicalInfoView: BaseUIView {
    
    private let patient = HISMartManager.share.currentPatient
    
    // MARK: Define controls
    private lazy var bloodGroupLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Nhóm máu: ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                weight: UIFont.Weight.medium
            ).normal(
                self.patient.bloodType,
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    private lazy var medicalDeviceIDLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Mã số thiết bị y tế: ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                weight: UIFont.Weight.medium
            ).normal(
                self.patient.TBPM_ID,
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    // MARK: Setup layout
    override func setupView() {
        self.backgroundColor = Theme.shared.darkBGColor
        self.setupBloodGroupLabel()
        self.setupMedicalDeviceIDLabel()
    }
    
    private func setupBloodGroupLabel() {
        self.addSubview(self.bloodGroupLabel)
        self.bloodGroupLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
        }
    }
    
    private func setupMedicalDeviceIDLabel() {
        self.addSubview(self.medicalDeviceIDLabel)
        self.medicalDeviceIDLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bloodGroupLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalTo(self.bloodGroupLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
}
