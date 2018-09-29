//
//  DoctorNameCell.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display Doctor Name has been shared by another Doctor about patient
class DoctorNameCell: BaseTableViewCell {
    
    // MARK: Define control
    private let doctorNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Layout UI
    override func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = Theme.shared.transparentColor
        self.layoutDoctorNameLabel()
    }
    
    private func layoutDoctorNameLabel() {
        self.addSubview(self.doctorNameLabel)
        self.doctorNameLabel.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func setValue(doctorName: String) {
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal(
                "Đến BS.",
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.captionFontSize,
                alpha: 0.54
            ).normal(
                doctorName,
                textColor: Theme.shared.darkBlueTextColor,
                fontSize: Dimension.shared.captionFontSize
        )
        
        doctorNameLabel.attributedText = formattedString
    }
}
