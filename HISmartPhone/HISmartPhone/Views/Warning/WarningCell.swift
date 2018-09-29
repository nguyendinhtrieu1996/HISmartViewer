//
//  WarningCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/28/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class WarningCell: BaseTableViewCell {
    
    var bloodPressure = BloodPressureNotification() {
        didSet {
            self.nameLabel.text = bloodPressure.patientName
            self.dateLabel.text = bloodPressure.createDate.getDescription_DDMMYYYY_HHMMSS()
            
            self.resultLabel.setMutableTextColorWithSlash(titles: [self.bloodPressure.systolic.description, self.bloodPressure.diastolic.description, self.bloodPressure.pulse.description],
                                                          colors: [Theme.shared.systolicChartColor,
                                                                   Theme.shared.diastolicChartColor,
                                                                   Theme.shared.heartRateChartColor],
                                                          fontSize: Dimension.shared.bodyFontSize)
            
            switch bloodPressure.alarmStatus {
            case .null:
                self.statusView.backgroundColor = Theme.shared.normalStatisticColor
                break
            case .low:
                self.statusView.backgroundColor = Theme.shared.lowStatisticColor
                break
            case .normal:
                self.statusView.backgroundColor = Theme.shared.normalStatisticColor
                break
            case .preHigh:
                self.statusView.backgroundColor = Theme.shared.hightStatisticColor
                break
            case .high:
                self.statusView.backgroundColor = Theme.shared.veryHightStatisticColor
                break
            }
        }
    }
    
    //MARK: UIControl
    private let statusView: UIView = {
        let view = UIView()
        
        view.backgroundColor = Theme.shared.hightStatisticColor
        view.layer.cornerRadius = Dimension.shared.widthStatusCircle / 2
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .right
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .right
        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.smallCaptionFontSize)
        
        return label
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = self.statusView.backgroundColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let lineDevider: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.lightBlueLineDivider
        return view
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewStatusView()
        self.setupViewNameLabel()
        self.setupViewResultLabel()
        self.setupViewDateLabel()
        self.setupViewTimeLabel()
        self.setupViewLineDevider()
    }
    
    //MARK: Handle UIControl
    
    //MARK: Feature
    
    //MARK: SetupView
    private func setupViewStatusView() {
        self.addSubview(self.statusView)
        
        if #available(iOS 11, *) {
            self.statusView.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthStatusCircle)
                make.top.equalToSuperview().offset(20 * Dimension.shared.heightScale)
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
            }
        } else {
            self.statusView.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthStatusCircle)
                make.top.equalToSuperview().offset(20 * Dimension.shared.heightScale)
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            }
        }
    }
    
    private func setupViewNameLabel() {
        self.addSubview(self.nameLabel)
        
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.statusView.snp.right).offset(Dimension.shared.largeHorizontalMargin)
            make.top.equalTo(self.statusView)
        }
    }
    
    private func setupViewDateLabel() {
        self.addSubview(self.dateLabel)
        
        if #available(iOS 11, *) {
            self.dateLabel.snp.makeConstraints { (make) in
                make.right.equalTo(self.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.normalHorizontalMargin)
                make.bottom.equalTo(self.resultLabel)
            }
        } else {
            self.dateLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
                make.bottom.equalTo(self.resultLabel)
            }
        }
    }
    
    private func setupViewTimeLabel() {
        self.addSubview(self.timeLabel)
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.dateLabel)
            make.centerY.equalTo(self.resultLabel)
        }
    }
    
    private func setupViewResultLabel() {
        self.addSubview(self.resultLabel)
        
        self.resultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
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






