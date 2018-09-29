//
//  CellInfoAccount.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class CellInfoAccount: BaseTableViewCell {
    
    var user: User? {
        didSet {
            let gender: String = (self.user?.gender == .male ? "Nam" : "Nữ")
            
            self.sexLabel.setMultableAttributedText(title: "Giới tính: ",
                                                    sizeTitle: Dimension.shared.bodyFontSize,
                                                    content: gender,
                                                    sizeContent: Dimension.shared.bodyFontSize)
            
            self.phoneNumberLabel.setMultableAttributedText(title: "Số điện thoại: ",
                                                sizeTitle: Dimension.shared.bodyFontSize,
                                                content: self.user?.mobile_Phone ?? "",
                                                sizeContent: Dimension.shared.bodyFontSize)
            
            self.addressLabel.setMultableAttributedText(title: "Cơ sở y tế: ",
                                                        sizeTitle: Dimension.shared.bodyFontSize,
                                                        content: self.user?.medicalCenterID ?? "",
                                                        sizeContent: Dimension.shared.bodyFontSize)
            
            self.DOBLabel.text = ""
            self.ageLabel.text = ""
        }
    }
    
    var patient = Patient() {
        didSet {
            let gender: String = (self.patient.sex_ID == .male ? "Nam" : "Nữ")
            
            self.sexLabel.setMultableAttributedText(title: "Giới tính: ",
                                                    sizeTitle: Dimension.shared.bodyFontSize,
                                                    content: gender,
                                                    sizeContent: Dimension.shared.bodyFontSize)
            
            self.phoneNumberLabel.setMultableAttributedText(title: "Số điện thoại: ",
                                                            sizeTitle: Dimension.shared.bodyFontSize,
                                                            content: self.patient.mobile_Phone,
                                                            sizeContent: Dimension.shared.bodyFontSize)
            
            self.addressLabel.setMultableAttributedText(title: "Địa chỉ: ",
                                                        sizeTitle: Dimension.shared.bodyFontSize,
                                                        content: self.patient.address?.getDescription() ?? "",
                                                        sizeContent: Dimension.shared.bodyFontSize)
            self.DOBLabel.setMultableAttributedText(title: "Ngày sinh: ",
                                                    sizeTitle: Dimension.shared.bodyFontSize,
                                                    content: self.patient.birth_Date.getDescription_DDMMYYYY_WithSlash(),
                                                    sizeContent: Dimension.shared.bodyFontSize)
            self.ageLabel.setMultableAttributedText(title: "Tuổi: ",
                                                    sizeTitle: Dimension.shared.bodyFontSize,
                                                    content: self.patient.birth_Date.getOld().description,
                                                    sizeContent: Dimension.shared.bodyFontSize)
        }
    }
    
    //MARK: UIControl
    private let sexLabel: UILabel = {
       let label = UILabel()
        label.setMultableAttributedText(title: "Giới tính: ",
                                        sizeTitle: Dimension.shared.bodyFontSize,
                                        content: "",
                                        sizeContent: Dimension.shared.bodyFontSize)
        return label
    }()
    
    private let DOBLabel: UILabel = {
        let label = UILabel()
        label.setMultableAttributedText(title: "Ngày sinh: ",
                                        sizeTitle: Dimension.shared.bodyFontSize,
                                        content: "",
                                        sizeContent: Dimension.shared.bodyFontSize)
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.setMultableAttributedText(title: "Tuổi: ",
                                        sizeTitle: Dimension.shared.bodyFontSize,
                                        content: "",
                                        sizeContent: Dimension.shared.bodyFontSize)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.setMultableAttributedText(title: "Số điện thoại: ",
                                        sizeTitle: Dimension.shared.bodyFontSize,
                                        content: "",
                                        sizeContent: Dimension.shared.bodyFontSize)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        
        label.setMultableAttributedText(title: "Địa chỉ: ",
                                        sizeTitle: Dimension.shared.bodyFontSize,
                                        content: "",
                                        sizeContent: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewSexLabel()
        self.setupViewDOBLabel()
        self.setupViewAgeLabel()
        self.setupViewPhoneNumberLabel()
        self.setupViewAddressLabel()
    }
    
    //MARK: SetupView
    private func setupViewSexLabel() {
        self.addSubview(self.sexLabel)
        
        self.sexLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewDOBLabel() {
        self.addSubview(self.DOBLabel)
        
        self.DOBLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.sexLabel)
            make.top.equalTo(self.sexLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewAgeLabel() {
        self.addSubview(self.ageLabel)
        
        self.ageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.DOBLabel.snp.right).offset(Dimension.shared.largeHorizontalMargin_60)
            make.centerY.equalTo(self.DOBLabel)
        }
    }
    
    private func setupViewPhoneNumberLabel() {
        self.addSubview(self.phoneNumberLabel)
        
        self.phoneNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.sexLabel)
            make.top.equalTo(self.DOBLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewAddressLabel() {
        self.addSubview(self.addressLabel)
        
        self.addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.sexLabel)
            make.top.equalTo(self.phoneNumberLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_32)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
}






