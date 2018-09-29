//
//  AlertDeleteDiagnose.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/26/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol AlertDeleteControllerDelegate: class {
    func didSelectDelete()
    func didSelectCancel()
}

class AlertDeleteController: BaseAlertViewController {
    
    var delegate: AlertDeleteControllerDelegate?
    
    //MARK: UIControl
    private let containtView: UIView = {
        let view = UIView()
        
        view.backgroundColor = Theme.shared.defaultBGColor
        view.layer.cornerRadius = Dimension.shared.normalCornerRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Bạn chắc chắn muốn \n xoá Chẩn đoán và \n Hướng dẫn điều trị này"
        label.textColor = Theme.shared.darkBlueTextColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("XÁC NHẬN", for: .normal)
        button.backgroundColor = Theme.shared.primaryColor
        button.layer.cornerRadius = Dimension.shared.heightButtonAlert / 2
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("HUỶ", for: .normal)
        button.backgroundColor = Theme.shared.accentColor
        button.layer.cornerRadius = Dimension.shared.heightButtonAlert / 2
        
        return button
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewContaintView()
        self.setupViewMessageLabel()
        self.setupViewAcceptButton()
        self.setupViewCancelButton()
    }
    
    //MARK: Action UIControl
    @objc func handleAcceptButton() {
        self.dismissAlert() 
        self.delegate?.didSelectDelete()
    }
    
    @objc func handleCancelButton() {
        self.dismissAlert()
        self.delegate?.didSelectCancel()
    }
    
    //MARK: Feature
    public func setMessage(_ message: String) {
        self.messageLabel.text = message
    }
    
    //MARK: SetupView
    private func setupViewContaintView() {
        self.view.addSubview(self.containtView)
        
        self.containtView.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.widthAlertDeleteDiagnose)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupViewMessageLabel() {
        self.containtView.addSubview(self.messageLabel)
        
        self.messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(38 * Dimension.shared.widthScale)
            make.right.equalToSuperview().offset(-38 * Dimension.shared.widthScale)
            make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewAcceptButton() {
        self.containtView.addSubview(self.acceptButton)
        
        self.acceptButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin_32)
            make.width.equalTo(Dimension.shared.widthButtonAlert)
            make.height.equalTo(Dimension.shared.heightButtonAlert)
            make.centerX.equalToSuperview()
        }
        
        self.acceptButton.addTarget(self, action: #selector(handleAcceptButton), for: .touchUpInside)
    }
    
    private func setupViewCancelButton() {
        self.containtView.addSubview(self.cancelButton)
        
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.acceptButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.width.equalTo(Dimension.shared.widthButtonAlert)
            make.height.equalTo(Dimension.shared.heightButtonAlert)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
        
        self.cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    }
    
}
