//
//  ShareInfoPatientAlertView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit


protocol ShareInfoPatientAlertViewDelegate: class {
    func handleCloseAlert()
}

// This class display info of patient and note for doctor
class ShareInfoPatientAlertView: BaseUIView {
    
    // MARK: Define variable
    weak var delegate: ShareInfoPatientAlertViewDelegate?
    
    // MARK: Define controls
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Share Hồ sơ thông tin"
        return label
    }()
    
    private let closeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(#imageLiteral(resourceName: "clear_black"), for: .normal)
        return button
    }()
    
    private let fromDoctorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Từ BS.",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                alpha: 0.54
            ).normal(
                "Nguyễn Văn A",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        label.attributedText = formattedString
        
        return label
    }()
    
    private let infoPatientLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.grayTextColor
        label.numberOfLines = 0
        label.text = "Thông tin bênh nhân"
        return label
    }()
    
    private let infoPatientView: PatientInfoView = PatientInfoView()
    
    private let noteTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.grayTextColor
        label.numberOfLines = 0
        label.text = "Lời nhắn kèm"
        return label
    }()
    
    private let noteContentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "There are many kinds of narratives and organizing principles. Science is driven by evidence gathered in experiments"
        return label
    }()
    
    // MARK: Setup UI
    override func setupView() {
        self.backgroundColor = Theme.shared.defaultBGColor
        self.layer.cornerRadius = Dimension.shared.normalCornerRadius
        self.setupTitleLabel()
        self.setupCloseButton()
        self.setupFromDoctorLabel()
        self.setupInfoPatientLabel()
        self.setupInfoPatientView()
//        self.setupNoteTitleLabel()
//        self.setupNoteContentLabel()
    }
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
        }
    }
    
    private func setupCloseButton() {
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
        self.closeButton.addTarget(self, action: #selector(ShareInfoPatientAlertView.handleCloseButton), for: .touchUpInside)
    }
    
    private func setupFromDoctorLabel() {
        self.addSubview(self.fromDoctorLabel)
        self.fromDoctorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(self.titleLabel)
        }
    }
    
    private func setupInfoPatientLabel() {
        self.addSubview(self.infoPatientLabel)
        self.infoPatientLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.fromDoctorLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
            make.left.right.equalTo(self.fromDoctorLabel)
        }
    }
    
    private func setupInfoPatientView() {
        self.addSubview(self.infoPatientView)
        self.infoPatientView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoPatientLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_42)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupNoteTitleLabel() {
        self.addSubview(self.noteTitleLabel)
        self.noteTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoPatientView.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
            make.left.right.equalTo(self.infoPatientLabel)
        }
    }
    
    private func setupNoteContentLabel() {
        self.addSubview(self.noteContentLabel)
        self.noteContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.noteTitleLabel.snp.bottom)
            make.left.right.equalTo(self.noteTitleLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    // MARK: Handel action
    @objc private func handleCloseButton() {
        self.delegate?.handleCloseAlert()
    }
    
    // MARK: Set data
    func setValue(patientBeShared: PatientBeShared) {
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Từ BS.",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize,
                alpha: 0.54
            ).normal(
                patientBeShared.doctorName,
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.bodyFontSize
        )
        
        self.fromDoctorLabel.attributedText = formattedString
        self.infoPatientView.setValue(patient: patientBeShared.patient)
    }
}



