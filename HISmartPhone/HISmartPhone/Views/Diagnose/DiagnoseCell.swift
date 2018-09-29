//
//  DiagnoseCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/26/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol DiagnoseCellDelegate: class {
    func didSelectItem(at indexPath: IndexPath)
}

class DiagnoseCell: BaseCollectionViewCell {
    
    var diagnose: Diagnose? {
        didSet {
            self.dateLabel.text = self.diagnose?.createDate.getDescription_DDMMYYYY_WithSlash()
            self.nameDoctorLabel.text = "BS." + (self.diagnose?.doctor.fullName ?? "")
        }
    }
    
    var prescription: Prescription? {
        didSet {
            let date = self.prescription?.createDate.getDescription_DDMMYYYY_WithSlash() ?? ""
            let presctiptionCode = (self.prescription?.prescriptionCode ?? "")
            self.dateLabel.text = (presctiptionCode.uppercased() + "  -  " + date)
            self.nameDoctorLabel.text = "BS." + (self.prescription?.doctor.fullName ?? "")
        }
    }
    
    weak var delegate: DiagnoseCellDelegate?
    private var indexPath = IndexPath()
    
    //MARK: UIControl
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let nameDoctorLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
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
        self.setupViewDateLabe()
        self.setupViewNameDoctorLabel()
        self.setupViewLineDivider()
        self.setupViewDeleteImage()
    }
    
    //MARK: Action UIControl
    @objc func handleCheckBox() {
        self.delegate?.didSelectItem(at: self.indexPath)
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
    private func setupViewDateLabe() {
        self.addSubview(self.dateLabel)
        
        if #available(iOS 11, *) {
            self.dateLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.left.equalTo(self.safeAreaLayoutGuide).offset(13 * Dimension.shared.widthScale)
            }
        } else {
            self.dateLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.left.equalToSuperview().offset(13 * Dimension.shared.widthScale)
            }
        }
    }
    
    private func setupViewNameDoctorLabel() {
        self.addSubview(self.nameDoctorLabel)
        
        self.nameDoctorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.dateLabel)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
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
