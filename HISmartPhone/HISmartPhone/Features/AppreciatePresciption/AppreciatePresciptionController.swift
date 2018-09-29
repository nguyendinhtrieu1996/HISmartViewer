//
//  AppreciatePresciptionController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol AppreciatePresciptionControllerDelegate: class {
    func saveAppreciate(_ message: String)
}

class AppreciatePresciptionController: BaseAlertViewController {
    
    weak var delegate: AppreciatePresciptionControllerDelegate?
    
    var message: String = "" {
        didSet {
            self.appreciateTextField.text = self.message
        }
    }
    
    //MARK: UIControl
    private let containtView: UIView = {
        let view = UIView()
        
        view.backgroundColor = Theme.shared.defaultBGColor
        view.layer.cornerRadius = Dimension.shared.normalCornerRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Đánh giá đơn thuốc"
        label.textColor = Theme.shared.darkBlueTextColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "clear_gray"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private lazy var appreciateTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "Nhập đánh giá"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let appreciateLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("LƯU", for: .normal)
        button.backgroundColor = Theme.shared.primaryColor
        button.layer.cornerRadius = Dimension.shared.heightButtonAlert / 2
        button.layer.masksToBounds = true
        
        return button
    }()
    
    //MARK: Initialize
    override func setupView() {
        super.setupView()
        self.setupViewContaintView()
        self.setupViewTitleLabel()
        self.setupViewCloseButton()
        self.setupViewAppreciateTextField()
        self.setupViewLineDevider()
        self.setupViewSaveButton()
        
        self.addTarget()
    }
    
    //MARK: Handle Action
    @objc func handleSaveButton() {
        guard let message = self.appreciateTextField.text else { return }
        self.delegate?.saveAppreciate(message)
        self.dismissAlert()
    }
    @objc func handleCloseButton() {
        self.dismissAlert()
    }
    
    @objc func textFieldBeginEdit(_ textField: UITextField) {
        self.appreciateLineDivider.backgroundColor = Theme.shared.primaryColor
    }
    
    @objc func textFieldValueChange(_ textField: UITextField) {
        guard let text = textField.text else {
            self.saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = Theme.shared.primaryColor
            return
        }
        
        if text == "" {
            self.saveButton.isUserInteractionEnabled = false
            self.saveButton.backgroundColor = Theme.shared.disableButtonColor
        } else {
            self.saveButton.isUserInteractionEnabled = true
            self.saveButton.backgroundColor = Theme.shared.primaryColor
        }
    }
    
    @objc func textFieldEndEdit(_ textField: UITextField) {
        self.appreciateLineDivider.backgroundColor = Theme.shared.lineDeviderColor
    }
    
    //MARK: Feature
    private func addTarget() {
        self.appreciateTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
         self.appreciateTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
         self.appreciateTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
    }
    
    //MARK: SetupView
    private func setupViewContaintView() {
        self.view.addSubview(self.containtView)
        
        self.containtView.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.largeWidthAlertAnnoucement)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupViewTitleLabel() {
        self.containtView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewAppreciateTextField() {
        self.containtView.addSubview(self.appreciateTextField)
        
        self.appreciateTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(38 * Dimension.shared.widthScale)
            make.right.equalToSuperview().offset(-38 * Dimension.shared.widthScale)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewLineDevider() {
        self.containtView.addSubview(self.appreciateLineDivider)
        
        self.appreciateLineDivider.snp.makeConstraints { (make) in
            make.left.equalTo(self.appreciateTextField).offset(-Dimension.shared.mediumHorizontalMargin)
            make.right.equalTo(self.appreciateTextField).offset(Dimension.shared.mediumHorizontalMargin)
            make.top.equalTo(self.appreciateTextField.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
    
    private func setupViewCloseButton() {
        self.containtView.addSubview(self.closeButton)
        
        self.closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24 * Dimension.shared.heightScale)
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
        
        self.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    private func setupViewSaveButton() {
        self.containtView.addSubview(self.saveButton)
        
        self.saveButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.widthButtonAlert)
            make.height.equalTo(Dimension.shared.heightButtonAlert)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.appreciateLineDivider.snp.bottom).offset(Dimension.shared.largeVerticalMargin_60)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
        
        self.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
    }
    
}











