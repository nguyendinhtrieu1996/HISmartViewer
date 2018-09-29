//
//  BloodResultPressureCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/25/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

enum StatusDeleteImage {
    case off, on, hide
}

protocol BloodResultPressureCellDelegate: class {
    func selectedCheckbox(at indexPath: IndexPath)
}

class BloodResultPressureCell: BaseCollectionViewCell {
    
    weak var delegate: BloodResultPressureCellDelegate?
    private var indexPath = IndexPath()
    
    weak var BPOResult: BPOResult? {
        didSet {
            self.dateLabel.text = self.BPOResult?.observation_Date.getDescription_DDMMYYYY_WithSlash()
            self.timeLabel.text = self.BPOResult?.observation_Date.getTimeDescription()
            
            self.resultLabel.setMutableTextColorWithSlash(titles: [self.BPOResult?.SYST.description ?? "",
                                                          self.BPOResult?.DIAS.description ?? "",
                                                          self.BPOResult?.PULS.description ?? ""],
                                                 colors: [Theme.shared.systolicChartColor,
                                                          Theme.shared.diastolicChartColor,
                                                          Theme.shared.heartRateChartColor],
                                                 fontSize: Dimension.shared.bodyFontSize)
            
            self.setStatusBloodPressure()
        }
    }
    
    private func setStatusBloodPressure() {
        guard let BPOPatient = HISMartManager.share.currentPatient.BPOPatient else { return }
        guard let BPOResult = self.BPOResult else { return }
        
        if (BPOResult.SYST <= BPOPatient.lowSystolic) && (BPOResult.DIAS <= BPOPatient.lowDiastolic) {
            self.circleStatus.backgroundColor = Theme.shared.lowStatisticColor
        } else if (BPOResult.SYST >= BPOPatient.highSystolic) || (BPOResult.DIAS >= BPOPatient.highDiastolic) {
            self.circleStatus.backgroundColor = Theme.shared.veryHightStatisticColor
        } else if (BPOResult.SYST >= BPOPatient.preHighSystolic) || (BPOResult.DIAS >= BPOPatient.preHighDiastolic) {
            self.circleStatus.backgroundColor = Theme.shared.hightStatisticColor
        } else {
            self.circleStatus.backgroundColor = Theme.shared.normalStatisticColor
        }
    }

    //MARK: UIControl
    private let circleStatus: UIView = {
        let view = UIView()
        
        view.backgroundColor = Theme.shared.lowStatisticColor
        view.layer.cornerRadius = Dimension.shared.widthStatusCircle / 2
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()

        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let deleteImage: UIImageView = {
        let image = UIImageView()
        
        image.isUserInteractionEnabled = true
        image.isHidden = true
        image.image = UIImage(named: "checkbox_off")
        
        return image
    }()
    
    private let lineDivider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7881147265, green: 0.8331988454, blue: 0.9022297263, alpha: 1)
        return view
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewCircleStatus()
        self.setupViewDateLabe()
        self.setupViewResultLabel()
        self.setupViewTimeLabel()
        self.setupViewLineDivider()
        self.setupViewDeleteImage()
    }
    
    //MARK: Action UIControl
    @objc func handleCheckBox() {
        self.delegate?.selectedCheckbox(at: self.indexPath)
    }
    
    //MARK: Feature
    func set(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func showImage(status: StatusDeleteImage) {
        switch status {
        case .on:
            self.deleteImage.isHidden = false
            self.deleteImage.image = UIImage(named: "checkbox_On")
            break
        case .off:
            self.deleteImage.isHidden = false
            self.deleteImage.image = UIImage(named: "checkbox_off")
            break
        case .hide:
            self.deleteImage.isHidden = true
            break
        }
    }
    
    //MARK: SetupView
    private func setupViewCircleStatus() {
        self.addSubview(self.circleStatus)
        
        if #available(iOS 11, *) {
            self.circleStatus.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(20 * Dimension.shared.heightScale)
                make.width.height.equalTo(Dimension.shared.widthStatusCircle)
            }
        } else {
            self.circleStatus.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(20 * Dimension.shared.heightScale)
                make.width.height.equalTo(Dimension.shared.widthStatusCircle)
            }
        }
    }
    
    private func setupViewDateLabe() {
        self.addSubview(self.dateLabel)
        
        if #available(iOS 11, *) {
            self.dateLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.circleStatus)
                make.left.equalTo(self.safeAreaLayoutGuide).offset(72 * Dimension.shared.widthScale)
            }
        } else {
            self.dateLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.circleStatus)
                make.left.equalToSuperview().offset(72 * Dimension.shared.widthScale)
            }
        }
    }
    
    private func setupViewResultLabel() {
        self.addSubview(self.resultLabel)
        
        self.resultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.dateLabel)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    private func setupViewTimeLabel() {
        self.addSubview(self.timeLabel)
        
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.dateLabel.snp.right).offset(Dimension.shared.largeHorizontalMargin)
            make.top.equalTo(self.dateLabel)
        }
    }
    
    private func setupViewDeleteImage() {
        self.addSubview(self.deleteImage)
        
        if #available(iOS 11, *) {
            self.deleteImage.snp.makeConstraints { (make) in
                make.width.height.equalTo(18 * Dimension.shared.widthScale)
                make.centerY.equalToSuperview()
                make.right.equalTo(self.safeAreaLayoutGuide).offset(-28 * Dimension.shared.widthScale)
            }
        } else {
            self.deleteImage.snp.makeConstraints { (make) in
                make.width.height.equalTo(18 * Dimension.shared.widthScale)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-28 * Dimension.shared.widthScale)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCheckBox))
        self.deleteImage.addGestureRecognizer(tapGesture)
    }
    
    private func setupViewLineDivider() {
        self.addSubview(self.lineDivider)
        
        self.lineDivider.snp.makeConstraints { (make) in
            make.centerX.width.bottom.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
}












