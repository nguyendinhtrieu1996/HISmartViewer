//
//  SuccessRegisterController.swift
//  HISmartPhone
//
//  Created by MACOS on 12/20/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class SuccessRegisterController: BaseViewController {
    
    //MARK: UIControl
    private var scrollView = BaseScrollView()
    
    private let logoImage: UIImageView = {
        let imageConfig = UIImageView()
        
        imageConfig.image = UIImage(named: "LOGO_BLUE")
        imageConfig.contentMode = .scaleAspectFit
        
        return imageConfig
    }()
    
    private let messageLabel: UILabel = {
        let labelConfig = UILabel()
        
        labelConfig.text = "Đăng kí thành công"
        labelConfig.textAlignment = .center
        labelConfig.textColor = Theme.shared.accentColor
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return labelConfig
    }()
    
    private let contentLabel: UILabel = {
        let labelConfig = UILabel()
        
        labelConfig.text = "Về trang chủ để cùng \nHISMartViewer bắt đầu theo dõi \ntình trạng sức khoẻ của bạn"
        labelConfig.textAlignment = .center
        labelConfig.numberOfLines = 0
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return labelConfig
    }()
    
    private let nextButton: UIButton = {
        let buttonConfig = UIButton()
        
        buttonConfig.setTitle("VỀ TRANG CHỦ", for: .normal)
        buttonConfig.setTitleColor(Theme.shared.defaultTextColor, for: .normal)
        buttonConfig.backgroundColor = Theme.shared.accentColor
        buttonConfig.titleLabel?.font = UIFont.systemFont(ofSize: Dimension.shared.titleButtonFontSize,
                                                          weight: UIFont.Weight.medium)
        buttonConfig.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        
        return buttonConfig
    }()
    
    //MARK: Initialize function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func setupView() {
        self.setupViewScrollView()
        self.setupViewLogoImage()
        self.setupViewMessageLabel()
        self.setupViewContentLabel()
        self.setupViewNextButton()
    }
    
    //MARK: Action UIControl
    @objc func nextButtonPressed() {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        if Authentication.share.typeUser == .doctor {
            window.rootViewController = UINavigationController(rootViewController: ListPatientController())
        } else {
            HISMartManager.share.setCurrentPatient(nil)
            window.rootViewController = TabBarController()
        }
    }
    
    //MARK: Feature function
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: SetupView function
    private func setupViewScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.scrollView.view.snp.makeConstraints { (make) in
            make.width.height.centerX.centerY.equalToSuperview()
        }
        
    }
    
    private func setupViewLogoImage() {
        self.scrollView.view.addSubview(self.logoImage)
        
        self.logoImage.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.widthImageLogo)
            make.height.equalTo(Dimension.shared.heightImageLogo)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(130 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewMessageLabel() {
        self.scrollView.view.addSubview(self.messageLabel)
        
        self.messageLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.logoImage.snp.bottom).offset(Dimension.shared.largeVerticalMargin_90)
        }
    }
    
    private func setupViewContentLabel() {
        self.scrollView.view.addSubview(self.contentLabel)
        
        self.contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.messageLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewNextButton() {
        self.scrollView.view.addSubview(self.nextButton)
        
        self.nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.contentLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin_32)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
        
        self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
}
