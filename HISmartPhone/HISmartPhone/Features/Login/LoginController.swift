//
//  ViewController.swift
//  HISmartPhone
//
//  Created by MACOS on 12/18/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import SnapKit

class LoginController: BaseViewController {
    
    //MARK: UIControl
    private var scrollView = UIScrollView()
    
    private let logoImage: UIImageView = {
        let imageConfig = UIImageView()
        
        imageConfig.image = UIImage(named: "LOGO_BLUE")
        imageConfig.contentMode = .scaleAspectFit
        
        return imageConfig
    }()
    
    private let codeTitleLabel: UILabel = {
        let labelConfig = UILabel()
        
        labelConfig.text = "Mã số bệnh nhân / bác sĩ"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .center
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return labelConfig
    }()
    
    private lazy var codeTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 0
        textfieldConfig.placeholder = "Nhập mã số"
        textfieldConfig.delegate = self
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor          
        
        return textfieldConfig
    }()
    
    private let codeLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
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
        
        textfieldConfig.tag = 1
        textfieldConfig.placeholder = "Nhập mật khẩu"
        textfieldConfig.delegate = self
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
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.accentColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let loginButton: UIButton = {
        let buttonConfig = UIButton()
        
        buttonConfig.isUserInteractionEnabled = false
        buttonConfig.setTitle("ĐĂNG NHẬP", for: .normal)
        buttonConfig.setTitleColor(Theme.shared.defaultTextColor, for: .normal)
        buttonConfig.backgroundColor = Theme.shared.disableButtonColor
        buttonConfig.titleLabel?.font = UIFont.systemFont(ofSize: Dimension.shared.titleButtonFontSize,
                                                          weight: UIFont.Weight.medium)
        buttonConfig.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        
        
        return buttonConfig
    }()
    
    private let registerButton: UIButton = {
        let buttonConfig = UIButton()
        
        buttonConfig.setTitle("ĐĂNG KÍ", for: .normal)
        buttonConfig.setTitleColor(Theme.shared.accentColor, for: .normal)
        buttonConfig.titleLabel?.font = UIFont.systemFont(ofSize: Dimension.shared.titleButtonFontSize,
                                                          weight: UIFont.Weight.medium)
        
        return buttonConfig
    }()
    
    //MARK: Initialize function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func setupView() {
        
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewPressed))
        self.view.addGestureRecognizer(tapGesture)
        
        self.setupViewScrollView()
        self.setupViewLogoImage()
        self.setupViewCodeTitleLabel()
        self.setupViewCodeTextfiled()
        self.setupViewCodeLineDivider()
        self.setupViewPassTitleLabel()
        self.setupViewPassTextfiled()
        self.setupViewPassLineDivider()
        self.setupViewErrorLabel()
        self.setupViewLoginButton()
        self.setupViewRegisterButton()
        
    }
    
    //MARK: Action UIControl
    @objc func loginButtonTapped() {
        self.view.endEditing(true)
        let username = self.codeTextField.text ?? ""
        let password = self.passTextField.text ?? ""
        self.codeTextField.isUserInteractionEnabled = false
        self.passTextField.isUserInteractionEnabled = false
        self.loginButton.isUserInteractionEnabled = false
        
        Authentication.share.signIn(username, password, completionHanlder: {
            HISMartManager.share.obseverMessage()
            
            if Authentication.share.typeUser == .doctor {
                _ = BeSharedManager.share
                guard let window = UIApplication.shared.keyWindow else { return }
                window.rootViewController = UINavigationController(rootViewController: ListPatientController())
            } else {
                guard let window = UIApplication.shared.keyWindow else { return }
                window.rootViewController = TabBarController()
            }
            
        }) {
            self.errorLabel.text = "Tên đăng nhập hoặc mật khẩu không đúng"
            self.loginButton.backgroundColor = Theme.shared.disableButtonColor
            self.codeTextField.isUserInteractionEnabled = true
            self.passTextField.isUserInteractionEnabled = true
            self.loginButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func registerButtonPressed() {
        self.navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.codeLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case 1:
            self.passLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        default:
            break
        }
    }
    
    @objc func textFieldValueChange(_ textField: UITextField) {
        self.checkShowLoginButton()
    }
    
    @objc func textFieldDindEndEdit(_ textField: UITextField) {
        self.checkShowLoginButton()
        
        switch textField.tag {
        case 0:
            self.codeLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case 1:
            self.passLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        default:
            break
        }
    }
    
    @objc func superViewPressed() {
        self.view.endEditing(true)
    }
    
    //MARK: Feature function
    private func checkShowLoginButton() {
        if let username = self.codeTextField.text, username != "", let password = self.passTextField.text, password != "" {
            self.loginButton.isUserInteractionEnabled = true
            self.loginButton.backgroundColor = Theme.shared.accentColor
        } else {
            self.loginButton.isUserInteractionEnabled = false
            self.loginButton.backgroundColor = Theme.shared.disableButtonColor
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.setupViewScrollView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: SetupView function
    private func setupViewScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if UIDevice.current.orientation.isPortrait {
            self.scrollView.isScrollEnabled = false
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: UIScreen.main.bounds.height)
        } else {
            self.scrollView.isScrollEnabled = true
            let height = UIScreen.main.bounds.height + 200 * Dimension.shared.heightScale
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: height)
        }
        
    }
    
    private func setupViewLogoImage() {
        self.scrollView.addSubview(self.logoImage)
        
        self.logoImage.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.widthImageLogo)
            make.height.equalTo(Dimension.shared.heightImageLogo)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_90)
        }
    }
    
    private func setupViewCodeTitleLabel() {
        self.scrollView.addSubview(self.codeTitleLabel)
        
        self.codeTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_42)
            make.top.equalTo(self.logoImage.snp.bottom).offset(68 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewCodeTextfiled() {
        self.scrollView.addSubview(self.codeTextField)
        
        self.codeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView).offset(Dimension.shared.largeHorizontalMargin_56)
            make.width.equalTo(self.view).offset(-2 * Dimension.shared.largeHorizontalMargin_56)
            make.top.equalTo(self.codeTitleLabel.snp.bottom).offset(20 * Dimension.shared.heightScale)
        }
        
        self.codeTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.codeTextField.addTarget(self, action: #selector(textFieldDindEndEdit(_:)), for: .editingDidEnd)
    }
    
    private func setupViewCodeLineDivider() {
        self.scrollView.addSubview(self.codeLineDivider)
        
        self.codeLineDivider.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView).offset(Dimension.shared.largeHorizontalMargin_42)
            make.width.equalTo(self.view).offset(-2 * Dimension.shared.largeHorizontalMargin_42)
            make.top.equalTo(self.codeTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
    
    private func setupViewPassTitleLabel() {
        self.view.addSubview(self.passTitleLabel)
        
        self.passTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel)
            make.top.equalTo(self.codeLineDivider.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupViewPassTextfiled() {
        self.scrollView.addSubview(self.passTextField)
        
        self.passTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.codeTextField)
            make.top.equalTo(self.passTitleLabel.snp.bottom).offset(20 * Dimension.shared.heightScale)
        }
        
        self.passTextField.addTarget(self, action: #selector(textFieldValueChange(_:)),
                                     for: .editingChanged)
        self.passTextField.addTarget(self, action: #selector(textFieldDindEndEdit(_:)),
                                     for: .editingDidEnd)
    }
    
    private func setupViewPassLineDivider() {
        self.scrollView.addSubview(self.passLineDivider)
        
        self.passLineDivider.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.codeLineDivider)
            make.top.equalTo(self.passTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
    
    private func setupViewErrorLabel() {
        self.scrollView.addSubview(self.errorLabel)
        
        self.errorLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.passLineDivider.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.height.equalTo(15 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewLoginButton() {
        self.scrollView.addSubview(self.loginButton)
        
        self.loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.largeWidthButton)
            make.centerX.equalToSuperview()
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.top.equalTo(self.errorLabel.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin)
        }
        
        self.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private func setupViewRegisterButton() {
        self.scrollView.addSubview(self.registerButton)
        
        self.registerButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(self.loginButton)
            make.top.equalTo(self.loginButton.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin)
        }
        
        self.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
    }
    
}

//MARK: - UITextFieldDelegate
extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
