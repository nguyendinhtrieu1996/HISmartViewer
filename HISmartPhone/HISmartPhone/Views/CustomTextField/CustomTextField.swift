//
//  CustomTextField.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/14/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

protocol CustomTextFieldDelegate: class {
    func editingBegin(customTextField: CustomTextField)
    func editingDidEnd(customTextField: CustomTextField)
    func editingChanged(customTextField: CustomTextField, text: String?)
}

// This class custom UITextField
class CustomTextField: BaseUIView {
    
    // MARK: Define variables
    weak var delegate: CustomTextFieldDelegate?
    
    // MARK: Define controls
    private var lineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    private (set) lazy var textField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.delegate = self
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    // MARK: Init
    init(placeholder: String, fontSize: CGFloat = Dimension.shared.bodyFontSize, keyboardType: UIKeyboardType = .default){
        super.init(frame: CGRect.zero)
        self.textField.placeholder = placeholder
        self.textField.keyboardType = keyboardType
        self.textField.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    override func setupView() {
        self.setupTextField()
        self.setupLineDivider()
    }
    
    private func setupLineDivider() {
        self.addSubview(self.lineDivider)
        self.lineDivider.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.textField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupTextField() {
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
        }
        
        self.textField.addTarget(self, action: #selector(CustomTextField.didSelectedTextfield), for: .editingDidBegin)
        self.textField.addTarget(self, action: #selector(CustomTextField.didEndEditingTextfield), for: .editingDidEnd)
        self.textField.addTarget(self, action: #selector(CustomTextField.editingChangedTextfield), for: .editingChanged)
    }
    
    @objc private func didSelectedTextfield() {
        self.lineDivider.backgroundColor = Theme.shared.primaryColor
        self.delegate?.editingBegin(customTextField: self)
    }
    
    @objc private func didEndEditingTextfield() {
        self.lineDivider.backgroundColor = Theme.shared.lineDeviderColor
        self.delegate?.editingDidEnd(customTextField: self)
    }
    
    @objc private func editingChangedTextfield() {
        self.delegate?.editingChanged(customTextField: self, text: self.textField.text)
    }

    // Set value
    func setValue(text: String) {
        self.textField.text = text
    }
}

//MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
