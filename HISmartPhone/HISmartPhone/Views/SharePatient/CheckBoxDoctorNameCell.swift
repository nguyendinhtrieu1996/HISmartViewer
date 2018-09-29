//
//  CheckBoxDoctorNameCell.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/3/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display checkbox and name of docter be shared by another doctor
class CheckBoxDoctorNameCell: BaseTableViewCell {
    
    // MARK: Define control
    private let checkBoxImage: UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "checkbox_On"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let doctorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Layout UI
    override func setupView() {
        self.selectionStyle = .none
        self.layoutCheckBoxImage()
        self.layoutDoctorNameLabel()
    }
    
    private func layoutCheckBoxImage() {
        self.addSubview(self.checkBoxImage)
        self.checkBoxImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            make.width.equalTo(self.checkBoxImage.snp.height)
        }
    }
    
    private func layoutDoctorNameLabel() {
        self.addSubview(self.doctorNameLabel)
        self.doctorNameLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalTo(self.checkBoxImage)
            make.left.equalTo(self.checkBoxImage.snp.right).offset(Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    func setValue(doctorName: String, isSelected: Bool) {
        self.doctorNameLabel.text = "Bs. \(doctorName)"
        self.checkBoxImage.image = isSelected ? UIImage(named: "checkbox_On") : UIImage(named: "checkbox_off")
    }
}
