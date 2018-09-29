//
//  DetailInfoChartCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/2/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class DetailInfoChartCell: BaseTableViewCell {
    
    var BPOResult: BPOResult? {
        didSet {
            guard let BPOResult = self.BPOResult else { return }
            self.dateLabel.text = self.BPOResult?.observation_Date.getDescription_DDMMYYYY_WithSlash()
            self.timeLabel.text = self.BPOResult?.observation_Date.getTimeDescription()
            
            self.systolicLabel.setMultableAttributedText(title: "Systolic:",
                                                         sizeTitle: Dimension.shared.captionFontSize,
                                                         content: "\t \(BPOResult.SYST.description)", sizeContent: Dimension.shared.captionFontSize,
                                                         color: Theme.shared.systolicChartColor)
            
            self.diastolicLabel.setMultableAttributedText(title: "Diastolic:", sizeTitle: Dimension.shared.captionFontSize, content: "\t \(BPOResult.DIAS.description)", sizeContent: Dimension.shared.captionFontSize, color: Theme.shared.diastolicChartColor)
            
            self.pulseLabel.setMultableAttributedText(title: "Pulse:", sizeTitle: Dimension.shared.captionFontSize, content: "\t \(BPOResult.PULS.description)", sizeContent: Dimension.shared.captionFontSize, color: Theme.shared.heartRateChartColor)
        }
    }
    
    //MARK: UIControl
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.smallCaptionFontSize)
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.smallCaptionFontSize)
        
        return label
    }()
    
    private let systolicLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.shared.darkBlueTextColor
        return label
    }()
    
    private let diastolicLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.shared.darkBlueTextColor
        return label
    }()
    
    private let pulseLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.shared.darkBlueTextColor
        return label
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewDateLabel()
        self.setupViewTimeLabel()
        self.setupViewSystolicLabel()
        self.setupViewDiastolicLabel()
        self.setupViewPulseLabel()
    }
    
    //MARK: SetupView
    private func setupViewDateLabel() {
        self.addSubview(self.dateLabel)
        
        if #available(iOS 11, *) {
            self.dateLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide).offset(Dimension.shared.mediumHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            }
        } else {
            self.dateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            }
        }
        
    }
    
    private func setupViewTimeLabel() {
        self.addSubview(self.timeLabel)
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.dateLabel)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewSystolicLabel() {
        self.addSubview(self.systolicLabel)
        
        self.systolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLabel)
            make.left.equalTo(self.dateLabel.snp.right).offset(Dimension.shared.largeHorizontalMargin_32)
        }
    }
    
    private func setupViewDiastolicLabel() {
        self.addSubview(self.diastolicLabel)
        
        self.diastolicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.systolicLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.systolicLabel)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewPulseLabel() {
        self.addSubview(self.pulseLabel)
        
        self.pulseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.diastolicLabel)
            make.left.equalTo(self.diastolicLabel.snp.right).offset(Dimension.shared.largeVerticalMargin_42)
        }
    }
    
}







