//
//  DetailPrescriptionCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/27/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class DetailPrescriptionCell: BaseTableViewCell {
    
    var orderNumber: Int = 0 {
        didSet {
            self.orderNumberLabel.text = self.orderNumber.description
        }
    }
    
    var prescription: Prescription = Prescription() {
        didSet {
            self.nameLabel.text = self.prescription.prescriptionName
            self.dateApplyLabel.text = self.prescription.dateApply
            self.noteLabel.text = self.prescription.comment
            self.quantityLabel.text = self.prescription.prescriptionQuantity.description
            self.evalueLabel.text = self.prescription.evaluation
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
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let dateApplyLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.lightBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let evalueLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.lightBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let lineDevider: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.lineDeviderColor
        return view
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewOrderNumberLabel()
        self.setupViewNameLabel()
        self.setupViewDateApplyLabel()
        self.setupViewQuantityLabel()
        self.setupViewNoteLabel()
        self.setupViewEvalueLabel()
        self.setupViewLineDevider()
    }
    
    //MARK: SetupView
    private func setupViewOrderNumberLabel() {
        self.addSubview(self.orderNumberLabel)
        
        self.orderNumberLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.smallHorizontalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.width.equalTo(16 * Dimension.shared.widthScale)
        }
    }
    
    private func setupViewNameLabel() {
        self.addSubview(self.nameLabel)
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.orderNumberLabel)
            make.left.equalTo(self.orderNumberLabel.snp.right).offset(Dimension.shared.mediumHorizontalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin_42)
        }
    }
    
    private func setupViewQuantityLabel() {
        self.addSubview(self.quantityLabel)
        
        self.quantityLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_120)
            make.centerY.equalTo(self.dateApplyLabel)
        }
    }
    
    private func setupViewDateApplyLabel() {
        self.addSubview(self.dateApplyLabel)
        
        self.dateApplyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.orderNumberLabel)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupViewNoteLabel() {
        self.addSubview(self.noteLabel)
        
        self.noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.nameLabel)
            make.right.equalTo(self.dateApplyLabel)
        }
    }
    
    private func setupViewEvalueLabel() {
        self.addSubview(self.evalueLabel)
        
        self.evalueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.noteLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.nameLabel)
            make.right.equalTo(self.dateApplyLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewLineDevider() {
        self.addSubview(self.lineDevider)
        
        self.lineDevider.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
    
}











