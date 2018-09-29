//
//  DeatailDiagnoseSickCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/26/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class DetailDiagnoseSickCell: BaseTableViewCell {
    
    weak var diagnose: Diagnose? {
        didSet {
            self.contentSickLabel.text = self.diagnose?.mainSick
            self.contentDiagnoseLabel.text = self.diagnose?.diagnose
        }
    }
    
    //MARK: UIControl
    private let titleSickLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Bệnh:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        return label
    }()
    
    private let contentSickLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let titleDiagnoseLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Chẩn đoán:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        return label
    }()
    
    private let contentDiagnoseLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let lineDivider: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.defaultBGColor
        return view
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewTitleSick()
        self.setupViewContainSickLabel()
        self.setupViewTitleDiagnoseLabel()
        self.setupViewContainDiagnoseLabel()
        self.setupViewLineDivider()
    }
    
    //MARK: Feature
    
    //MARK: SetupView
    private func setupViewTitleSick() {
        self.addSubview(self.titleSickLabel)
        
        if #available(iOS 11, *) {
            self.titleSickLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            }
        } else {
            self.titleSickLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            }
        }
    }
    
    private func setupViewContainSickLabel() {
        self.addSubview(self.contentSickLabel)
        
        if #available(iOS 11, *) {
            self.contentSickLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide).offset(127 * Dimension.shared.widthScale)
                make.top.equalTo(self.titleSickLabel)
                make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            }
        } else {
            self.contentSickLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(127 * Dimension.shared.widthScale)
                make.top.equalTo(self.titleSickLabel)
                make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            }
        }
    }
    
    private func setupViewTitleDiagnoseLabel() {
        self.addSubview(self.titleDiagnoseLabel)
        
        self.titleDiagnoseLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleSickLabel)
            make.top.equalTo(self.contentSickLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewContainDiagnoseLabel() {
        self.addSubview(self.contentDiagnoseLabel)
        
        self.contentDiagnoseLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentSickLabel)
            make.top.equalTo(self.titleDiagnoseLabel)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupViewLineDivider() {
        self.addSubview(self.lineDivider)
        
        self.lineDivider.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.height.equalTo(Dimension.shared.largeVerticalMargin)
            make.top.equalTo(self.titleDiagnoseLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }
}










