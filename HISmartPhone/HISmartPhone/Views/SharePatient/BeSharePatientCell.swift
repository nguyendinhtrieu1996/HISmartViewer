//
//  BeSharePatientCell.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/27/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display information of Patient
class BeSharePatientCell: BaseTableViewCell {
    
    // MARK: Define variable
    weak var delegate: SharePatientDelegate?
    
    //MARK: Define control
    private let circleView: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.heartRateChartColor
        viewConfig.layer.cornerRadius = Dimension.shared.widthStatusCircle / 2
        viewConfig.layer.masksToBounds = true
        return viewConfig
    }()
    
    private let patientNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        return label
    }()
    
    private let doctorName: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
//    private let noteButton: UIButton = {
//        let button : UIButton = UIButton()
//        button.setBackgroundImage(#imageLiteral(resourceName: "note"), for: .normal)
//        return button
//    }()

    
//    @objc private func showNote() {
//        self.delegate?.showNoteAlert()
//    }
    
    // MARK: Setup UI
    override func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = Theme.shared.transparentColor
        self.layoutCircleView()
        self.layoutPatientNameLabel()
        self.layoutDoctorNameLabel()
    }
    
    private func layoutCircleView() {
        self.addSubview(self.circleView)
        self.circleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.width.height.equalTo(15)
        }
    }
    
//    private func layoutNoteButton() {
//        self.addSubview(self.noteButton)
//        self.noteButton.snp.makeConstraints { (make) in
//            make.top.equalTo(self.unSharedButton)
//            make.right.equalTo(self.unSharedButton.snp.left).offset(-Dimension.shared.largeHorizontalMargin_32)
//        }
//        self.noteButton.addTarget(self, action: #selector(BeSharePatientCell.showNote), for: .touchUpInside)
//    }
    
    private func layoutPatientNameLabel() {
        self.addSubview(self.patientNameLabel)
        self.patientNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_60)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func layoutDoctorNameLabel() {
        self.addSubview(self.doctorName)
        self.doctorName.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientNameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(self.patientNameLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    // MARK: SetData
    func setValue(patientShared: SharePatientByDoctor) {
        self.patientNameLabel.text = "\(patientShared.patientName) / \(patientShared.patientInfo.patient_ID)"
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Từ BS.  ",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.captionFontSize,
                alpha: 0.54
            ).normal(
                patientShared.fullName,
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.captionFontSize
        )
        
        self.doctorName.attributedText = formattedString
    }
}
