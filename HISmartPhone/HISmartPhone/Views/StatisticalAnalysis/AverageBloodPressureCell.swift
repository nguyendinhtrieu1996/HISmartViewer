//
//  StatisticalAnalysisCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/25/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class AverageBloodPressureCel: BaseTableViewCell {
    
    func setData() {
        self.titleLabel.text = "Huyết áp trung bình:      \(BPOHelper.shared.averageBPO)"
        self.minimumLabel.text = "Minimum:  \(BPOHelper.shared.minimumValue)"
        self.maximumLabel.text = "Maximum:  \(BPOHelper.shared.maximumValue)"
    }
    
    //MARK: UIControl
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let minimumLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let maximumLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewTitleLabel()
        self.setupViewMinimumLabel()
        self.setupViewMaximumLabel()
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
    
    private func setupViewMinimumLabel() {
        self.addSubview(self.minimumLabel)
        
        if #available(iOS 11, *) {
            self.minimumLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeVerticalMargin_56)
                make.top.equalTo(self.titleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.minimumLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_56)
                make.top.equalTo(self.titleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewMaximumLabel() {
        self.addSubview(self.maximumLabel)
        
        self.maximumLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.minimumLabel)
            make.top.equalTo(self.minimumLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.height.equalTo(14 * Dimension.shared.heightScale)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
}




