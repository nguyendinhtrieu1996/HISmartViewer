//
//  SurpassTheThresholdCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/26/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class SurpassTheThresholdCell: BaseTableViewCell {
    
    func setData() {
        self.titleLabel.text = "Tổng số lần vượt ngưỡng: \(BPOHelper.shared.totalNumberHighBPO) lần / \(BPOHelper.shared.BPOResults.count) lần"
        self.lowBloodPressureLabel.text = "Huyết áp thấp:  \(BPOHelper.shared.numberLowBPO) lần"
        self.highBloodPressureLabel.text = "Huyết áp cao:  \(BPOHelper.shared.numberHighBPO) lần"
        self.veryHighBloodPressureLabel.text = "Huyết áp rất cao:  \(BPOHelper.shared.numberVeryHighBPO) lần"
    }
    
    //MARK: UIControl
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let lowBloodPressureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let highBloodPressureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let veryHighBloodPressureLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewTitleLabel()
        self.setupViewLowBloodPressureLabel()
        self.setupViewHighBloodPressureLabel()
        self.setupViewVeryHighBloodPressureLabel()
    }
    
    //MARK: SetupView
    private func setupViewTitleLabel() {
        self.addSubview(self.titleLabel)
        
        if #available(iOS 11, *) {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
            }
        } else {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
            }
        }
    }
    
    private func setupViewLowBloodPressureLabel() {
        self.addSubview(self.lowBloodPressureLabel)
        
        if #available(iOS 11, *) {
            self.titleLabel.snp.makeConstraints { (make) in
                self.lowBloodPressureLabel.snp.makeConstraints { (make) in
                    make.left.equalTo(self.safeAreaLayoutGuide)
                        .offset(Dimension.shared.largeVerticalMargin_56)
                    make.top.equalTo(self.titleLabel.snp.bottom)
                        .offset(Dimension.shared.normalVerticalMargin)
                }
            }
        } else {
            self.lowBloodPressureLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_56)
                make.top.equalTo(self.titleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewHighBloodPressureLabel() {
        self.addSubview(self.highBloodPressureLabel)
        
        self.highBloodPressureLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.lowBloodPressureLabel)
            make.top.equalTo(self.lowBloodPressureLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewVeryHighBloodPressureLabel() {
        self.addSubview(self.veryHighBloodPressureLabel)
        
        self.veryHighBloodPressureLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.lowBloodPressureLabel)
            make.top.equalTo(self.highBloodPressureLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
            make.height.equalTo(15 * Dimension.shared.heightScale)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
    }
    
}
