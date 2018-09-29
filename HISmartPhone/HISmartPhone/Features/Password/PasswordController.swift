//
//  PasswordController.swift
//  HISmartPhone
//
//  Created by MACOS on 12/20/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PasswordController: BaseViewController {
    
    //MARK: UIControl
    private var scrollView = BaseScrollView()
    
    private let passTitleLabel: UILabel = {
        let labelConfig = UILabel()
        
        labelConfig.text = "Mật khẩu"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .center
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return labelConfig
    }()
    
    private lazy var passTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 0
        textfieldConfig.placeholder = "Nhập mật khẩu"
        textfieldConfig.isSecureTextEntry = true
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let passLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    private let requiredPassTitleLabel: UILabel = {
        let labelConfig = UILabel()
        
        labelConfig.text = "Nhập lại mật khẩu"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .center
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return labelConfig
    }()
    
    private lazy var requiredPassTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 1
        textfieldConfig.placeholder = "Nhập lại mật khẩu"
        textfieldConfig.isSecureTextEntry = true
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let errorLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = Theme.shared.accentColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let requiredPassLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    private let nextButton: UIButton = {
        let buttonConfig = UIButton()
        
        buttonConfig.isUserInteractionEnabled = false
        buttonConfig.setTitle("TIẾP THEO", for: .normal)
        buttonConfig.setTitleColor(Theme.shared.defaultTextColor, for: .normal)
        buttonConfig.backgroundColor = Theme.shared.disableButtonColor
        buttonConfig.titleLabel?.font = UIFont.systemFont(ofSize: Dimension.shared.titleButtonFontSize,
                                                          weight: UIFont.Weight.medium)
        buttonConfig.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        
        return buttonConfig
    }()
    
    //MARK: Initialize function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = Theme.shared.defaultBGColor
    }
    
    override func setupView() {
        IQKeyboardManager.sharedManager().enable = true
        
        self.setupViewNavigationBar()
        self.setupViewScrollView()
        self.setupViewPassTitleLabel()
        self.setupViewPassTextfiled()
        self.setupViewPassLineDivider()
        self.setupViewRequiredPassTitleLabel()
        self.setupViewRequiredPassTextfiled()
        self.setupViewRequiredPassLineDivider()
        self.setupViewErrorLabel()
        self.setupViewNextButton()
    }
    
    //MARK: Action UIControl
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonPressed() {
        self.passTextField.isUserInteractionEnabled = false
        self.requiredPassTextField.isUserInteractionEnabled = false
        self.nextButton.isUserInteractionEnabled = false
        Authentication.share.register(with: self.passTextField.text ?? "", completion: {
            self.navigationController?.pushViewController(SuccessRegisterController(), animated: true)
        }) {
            self.passTextField.isUserInteractionEnabled = true
            self.requiredPassTextField.isUserInteractionEnabled = true
            self.nextButton.isUserInteractionEnabled = true
            self.errorLabel.text = "Lỗi kiểm tra lại thông tin!"
        }
        
    }
    
    @objc func textFieldBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.passLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case 1:
            self.requiredPassLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        default:
            break
        }
        
        self.checkShowNextButton()
    }
    
    @objc func textFieldDidEditing(_ textField: UITextField) {
        self.checkShowNextButton()
    }
    
    @objc func textFieldEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.passLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case 1:
            self.requiredPassLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        default:
            break
        }
    }
    
    //MARK: Feature function
    
    private func checkShowNextButton() {
        guard let pass = self.passTextField.text else { return }
        guard let rePass = self.requiredPassTextField.text else { return }
        
        if pass != rePass || pass == "" {
            self.nextButton.backgroundColor = Theme.shared.disableButtonColor
            self.nextButton.isUserInteractionEnabled = false
        } else {
            self.nextButton.backgroundColor = Theme.shared.accentColor
            self.nextButton.isUserInteractionEnabled = true
        }
    }
    
    //MARK: SetupView function
    private func setupViewNavigationBar() {
        //BACK BUTTON
        self.navigationItem.addLeftBarItem(with: UIImage(named: "Blue_Back_Item"),
                                           target: self,
                                           selector: #selector(backButtonPressed),
                                           title: "Đăng kí")
        
        //IMGAE LOGO
        let imageLogo = UIImageView(image: UIImage(named: "LOGO_BLUE"))
        imageLogo.contentMode = .scaleAspectFit
        imageLogo.frame = CGRect(x: 0, y: 0, width: 62, height: 28)
        let imageLogoItem = UIBarButtonItem(customView: imageLogo)
        self.navigationItem.rightBarButtonItem = imageLogoItem
    }
    
    private func setupViewScrollView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.scrollView.view.snp.remakeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.view)
        }
        
    }
    
    private func setupViewPassTitleLabel() {
        self.scrollView.view.addSubview(self.passTitleLabel)
        
        if #available(iOS 11, *) {
            self.passTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide).offset(26 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_56)
            }
        } else {
            self.passTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(26 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_56)
            }
        }
    }
    
    private func setupViewPassTextfiled() {
        self.scrollView.view.addSubview(self.passTextField)
        
        self.passTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.passTitleLabel).offset(Dimension.shared.smallHorizontalMargin)
            make.width.equalToSuperview().offset(-2 * Dimension.shared.largeHorizontalMargin_56)
            make.top.equalTo(self.passTitleLabel.snp.bottom).offset(20 * Dimension.shared.heightScale)
        }
        
        self.passTextField.addTarget(self, action: #selector(textFieldBeginEditing(_:)), for: .editingDidBegin)
        self.passTextField.addTarget(self, action: #selector(textFieldDidEditing(_:)), for: .editingChanged)
        self.passTextField.addTarget(self, action: #selector(textFieldEndEditing(_:)), for: .editingDidEnd)
    }
    
    private func setupViewPassLineDivider() {
        self.scrollView.view.addSubview(self.passLineDivider)
        
        if #available(iOS 11, *) {
            self.passLineDivider.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeHorizontalMargin)
                
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.largeHorizontalMargin_42)
                
                make.top.equalTo(self.passTextField.snp.bottom)
                    .offset(Dimension.shared.smallHorizontalMargin)
                make.height.equalTo(Dimension.shared.heightLineDivider)
            }
        } else {
            self.passLineDivider.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.width.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_42)
                make.top.equalTo(self.passTextField.snp.bottom)
                    .offset(Dimension.shared.smallHorizontalMargin)
                make.height.equalTo(Dimension.shared.heightLineDivider)
            }
        }
    }
    
    private func setupViewRequiredPassTitleLabel() {
        self.scrollView.view.addSubview(self.requiredPassTitleLabel)
        
        self.requiredPassTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.passTitleLabel)
            make.top.equalTo(self.passLineDivider.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewRequiredPassTextfiled() {
        self.scrollView.view.addSubview(self.requiredPassTextField)
        
        self.requiredPassTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.passTextField)
            make.top.equalTo(self.requiredPassTitleLabel.snp.bottom)
                .offset(20 * Dimension.shared.heightScale)
        }
        
        self.requiredPassTextField.addTarget(self, action: #selector(textFieldBeginEditing(_:)), for: .editingDidBegin)
        self.requiredPassTextField.addTarget(self, action: #selector(textFieldDidEditing(_:)), for: .editingChanged)
        self.requiredPassTextField.addTarget(self, action: #selector(textFieldEndEditing(_:)), for: .editingDidEnd)
    }
    
    private func setupViewRequiredPassLineDivider() {
        self.scrollView.view.addSubview(self.requiredPassLineDivider)
        
        self.requiredPassLineDivider.snp.makeConstraints { (make) in
            make.left.width.equalTo(self.passLineDivider)
            make.top.equalTo(self.requiredPassTextField.snp.bottom)
                .offset(Dimension.shared.smallHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
    
    private func setupViewErrorLabel() {
        self.scrollView.view.addSubview(self.errorLabel)
        
        self.errorLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.requiredPassTextField.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
            make.height.equalTo(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewNextButton() {
        self.scrollView.view.addSubview(self.nextButton)
        
        self.nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.errorLabel.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin_90)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
        
        self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
    
}
