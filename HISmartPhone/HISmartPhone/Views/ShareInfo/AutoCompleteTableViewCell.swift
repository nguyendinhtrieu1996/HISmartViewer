//
//  AutoCompleteTableViewCell.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display DoctorName - User can choose doctor name for auto complete textfield
class AutoCompleteTableViewCell: BaseTableViewCell {
    
    // MARK: Define control
    private let doctorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Setup UI
    override func setupView() {
        self.backgroundColor = Theme.shared.transparentColor
        self.setupDoctorNameLabel()
    }
    
    private func setupDoctorNameLabel() {
        self.addSubview(self.doctorNameLabel)
        self.doctorNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    func setValue(doctorName: String) {
        self.doctorNameLabel.text = doctorName
    }
}
