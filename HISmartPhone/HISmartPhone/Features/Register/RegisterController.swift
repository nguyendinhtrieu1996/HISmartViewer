//
//  RegisterController.swift
//  HISmartPhone
//
//  Created by MACOS on 12/19/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import BEMCheckBox

class RegisterController: BaseViewController {

    enum TypeTextField: Int {
        case code = 0, name, DOB, address, phoneNumber, email
    }

    fileprivate var patientRegister = Patient()
    fileprivate var listAddress = [Address]()

    //MARK: UIControl
    private var scrollView = BaseScrollView()
    private var group = BEMCheckBoxGroup()

    fileprivate let datePicker: UIDatePicker = {
        let datePickerConfig = UIDatePicker()

        datePickerConfig.datePickerMode = .date
        datePickerConfig.locale = Locale(identifier: "vi-VN")

        return datePickerConfig
    }()

    fileprivate lazy var addressPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()

    //MARK: CODE
    private let codeTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Mã số bệnh nhân liên kết"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    private lazy var codeTextField: UITextField = {
        let textfieldConfig = UITextField()

        textfieldConfig.tag = 0
        textfieldConfig.placeholder = "Mã số liên kết"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor

        return textfieldConfig
    }()

    private let codeLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()

    //MARK: NAME
    private let nameTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Họ và tên"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    private lazy var nameTextField: UITextField = {
        let textfieldConfig = UITextField()

        textfieldConfig.tag = 1
        textfieldConfig.placeholder = "Họ và tên"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor

        return textfieldConfig
    }()

    private let nameLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()

    //MARK: DATE OF BIRTH
    private let DOBTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Ngày sinh"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    private lazy var DOBTextField: UITextField = {
        let textfieldConfig = UITextField()

        textfieldConfig.tag = 2
        textfieldConfig.placeholder = "dd/mm/yyyy"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        textfieldConfig.inputView = self.datePicker

        return textfieldConfig
    }()

    private var dropImage: UIImageView = {
        let imageConfig = UIImageView()

        imageConfig.image = UIImage(named: "Drop_item")
        imageConfig.contentMode = .scaleAspectFill

        return imageConfig
    }()

    private let DOBLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()

    //MARK: GENDER
    private let genderTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Giới tính"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    fileprivate lazy var maleCheckBox: BEMCheckBox = {
        let checkBox = BEMCheckBox()

        checkBox.tag = 0
        checkBox.on = true
        checkBox.boxType = .circle
        checkBox.onAnimationType = BEMAnimationType.fill
        checkBox.onFillColor = Theme.shared.primaryColor
        checkBox.onTintColor = Theme.shared.primaryColor
        checkBox.onCheckColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        checkBox.animationDuration = 0.2
        checkBox.delegate = self

        return checkBox
    }()

    private let maleTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Nam"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    fileprivate lazy var femaleCheckBox: BEMCheckBox = {
        let checkBox = BEMCheckBox()

        checkBox.tag = 1
        checkBox.on = false
        checkBox.boxType = .circle
        checkBox.onAnimationType = BEMAnimationType.fill
        checkBox.onFillColor = Theme.shared.primaryColor
        checkBox.onTintColor = Theme.shared.primaryColor
        checkBox.onCheckColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        checkBox.animationDuration = 0.2
        checkBox.delegate = self

        return checkBox
    }()

    private let femaleTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Nữ"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    //MARK: ADDRESS
    private let addressTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Địa chỉ"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    private lazy var addressTextField: UITextField = {
        let textfieldConfig = UITextField()

        textfieldConfig.tag = 3
        textfieldConfig.placeholder = "Địa chỉ chỗ ở hiện tại (Số nhà, đường...)"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        textfieldConfig.inputView = self.addressPicker

        return textfieldConfig
    }()

    private let addressLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()

    //MARK: PHONE
    private let phoneTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Số điện thoại"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    private lazy var phoneTextField: UITextField = {
        let textfieldConfig = UITextField()

        textfieldConfig.tag = 4
        textfieldConfig.keyboardType = .phonePad
        textfieldConfig.placeholder = "Nhập số điện thoại"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor

        return textfieldConfig
    }()

    private let phoneLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()

    //MARK: EMAIL
    private let emailTitleLabel: UILabel = {
        let labelConfig = UILabel()

        labelConfig.text = "Email"
        labelConfig.textColor = Theme.shared.darkBlueTextColor
        labelConfig.textAlignment = .left
        labelConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return labelConfig
    }()

    private lazy var emailTextField: UITextField = {
        let textfieldConfig = UITextField()

        textfieldConfig.tag = 5
        textfieldConfig.keyboardType = .emailAddress
        textfieldConfig.placeholder = "Email@sample.com"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor

        return textfieldConfig
    }()

    private let emailLineDivider: UIView = {
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
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = Theme.shared.darkBlueTextColor
        self.navigationController?.navigationBar.barTintColor = Theme.shared.defaultBGColor
    }

    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewScrollView()
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        //CODE
        self.setupViewCodeTitleLabel()
        self.setupViewCodeTextfiled()
        self.setupViewCodeLineDivider()
        //NAME
        self.setupViewNameTitleLabel()
        self.setupViewNameTextfiled()
        self.setupViewNameLineDivider()
        //DOB
        self.setupViewDOBTitleLabel()
        self.setupViewDOBTextfiled()
        self.setupViewDropItemImage()
        self.setupViewDOBLineDivider()
        //GENDER
        self.setupViewGenderTitleLabel()
        self.setupViewMaleCheckBox()
        self.setupViewMaleTitleLabel()
        self.setupViewFeMaleCheckBox()
        self.setupViewFeMaleTitleLabel()
        //ADDRESS
        self.setupViewAddressTitleLabel()
        self.setupViewAddressTextfield()
        self.setupViewAddressLineDivider()
        //PHONE
        self.setupViewPhoneTitleLabel()
        self.setupViewPhoneTextField()
        self.setupViewPhoneLineDivider()
        //EMAIL
        self.setupViewEmailTitleLabel()
        self.setupViewEmailTextField()
        self.setupViewEmailLineDivider()

        self.setupViewNextButton()
        self.addTargetForTextField()


        self.group = BEMCheckBoxGroup(checkBoxes: [self.maleCheckBox, self.femaleCheckBox])
        self.group.selectedCheckBox = self.maleCheckBox
        self.group.mustHaveSelection = true

        RegisterFacade.fetchAllAddress(completion: { (listAddress) in
            self.listAddress = listAddress
            self.addressPicker.reloadAllComponents()
        }) {
            //
        }

    }

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        DispatchQueue.main.async {
//            self.setupViewScrollView()
//        }
//    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {

    }

    //MARK: Action UIControl
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func textFieldBeginEdit(_ textField: UITextField) {
        guard let type = TypeTextField(rawValue: textField.tag) else { return }

        switch type {
        case .code:
            self.codeLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .name:
            self.nameLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .DOB:
            self.DOBLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .address:
            self.addressLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .phoneNumber:
            self.phoneLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .email:
            self.emailLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        }
    }

    @objc func textFieldValueChange(_ textField: UITextField) {
        guard let type = TypeTextField(rawValue: textField.tag) else { return }
        guard let text = textField.text else { return }

        switch type {
        case .code:
            self.patientRegister.setPatientID(text)
            break
        case .name:
            self.patientRegister.setPatientName(text)
            break
        case .phoneNumber:
            self.patientRegister.setPhoneNumber(text)
            break
        case .email:
            self.patientRegister.setEmail(text)
            break
        default:
            break
        }

        self.checkShowNextButton()
    }

    @objc func textFieldEndEdit(_ textField: UITextField) {
        guard let type = TypeTextField(rawValue: textField.tag) else { return }

        switch type {
        case .code:
            self.codeLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .name:
            self.nameLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .DOB:
            self.DOBLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .address:
            self.addressLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .phoneNumber:
            self.phoneLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .email:
            self.emailLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        }

        self.checkShowNextButton()
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.DOBTextField.text = dateFormatter.string(from: sender.date)
        self.patientRegister.setBirthDate(sender.date)
    }

    @objc func nextButtonPressed() {
        Authentication.share.setPatientRegidter(self.patientRegister)
        self.navigationController?.pushViewController(PasswordController(), animated: true)
    }

    //MARK: Feature
    private func addTargetForTextField() {
        //Touch Up Inside
        self.codeTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.nameTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.DOBTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.addressTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.phoneTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.emailTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)

        //Value change
        self.codeTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.nameTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.DOBTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.addressTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.phoneTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)

        //End editing
        self.codeTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.nameTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.DOBTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.addressTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.phoneTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.emailTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
    }

    fileprivate func checkShowNextButton() {
        if self.patientRegister.isFillAllInfo() {
            self.nextButton.isUserInteractionEnabled = true
            self.nextButton.backgroundColor = Theme.shared.accentColor
        } else {
            self.nextButton.isUserInteractionEnabled = false
            self.nextButton.backgroundColor = Theme.shared.disableButtonColor
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

    @objc private func setupViewScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { (make) in
            make.top.left.top.equalToSuperview()
            make.width.equalToSuperview()
        }

    }

    //MARK: CODE
    private func setupViewCodeTitleLabel() {
        self.scrollView.addSubview(self.codeTitleLabel)

        if #available(iOS 11, *) {
            self.codeTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(26 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
            }
        } else {
            self.codeTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(26 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
            }
        }
    }

    private func setupViewCodeTextfiled() {
        self.scrollView.addSubview(self.codeTextField)

        self.codeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel).offset(Dimension.shared.mediumHorizontalMargin)
            make.width.equalTo(self.view).offset(-Dimension.shared.largeHorizontalMargin_56)
            make.top.equalTo(self.codeTitleLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewCodeLineDivider() {
        self.scrollView.addSubview(self.codeLineDivider)

        self.codeLineDivider.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel)
            make.width.equalTo(self.view).offset(-2 * Dimension.shared.largeHorizontalMargin)
            make.top.equalTo(self.codeTextField.snp.bottom)
                .offset(Dimension.shared.smallHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }

    //MARK: NAME
    private func setupViewNameTitleLabel() {
        self.scrollView.addSubview(self.nameTitleLabel)

        self.nameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel)
            make.top.equalTo(self.codeLineDivider).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewNameTextfiled() {
        self.scrollView.addSubview(self.nameTextField)

        self.nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.codeTextField)
            make.top.equalTo(self.nameTitleLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewNameLineDivider() {
        self.scrollView.addSubview(self.nameLineDivider)

        self.nameLineDivider.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.codeLineDivider)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
        }
    }

    //MARK: DOB
    private func setupViewDOBTitleLabel() {
        self.scrollView.addSubview(self.DOBTitleLabel)

        self.DOBTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel)
            make.top.equalTo(self.nameLineDivider).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewDOBTextfiled() {
        self.scrollView.addSubview(self.DOBTextField)

        self.DOBTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTextField)
            make.width.equalTo(Dimension.shared.widthTextfieldDOB)
            make.top.equalTo(self.DOBTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewDropItemImage() {
        self.scrollView.addSubview(self.dropImage)

        self.dropImage.snp.makeConstraints { (make) in
            make.width.equalTo(10 * Dimension.shared.widthScale)
            make.height.equalTo(5 * Dimension.shared.heightScale)
            make.bottom.equalTo(self.DOBTextField).offset(-Dimension.shared.smallVerticalMargin)
            make.left.equalTo(self.DOBTextField.snp.right)
        }
    }

    private func setupViewDOBLineDivider() {
        self.scrollView.addSubview(self.DOBLineDivider)

        self.DOBLineDivider.snp.makeConstraints { (make) in
            make.left.height.equalTo(self.codeLineDivider)
            make.right.equalTo(self.dropImage).offset(Dimension.shared.smallHorizontalMargin)
            make.top.equalTo(self.DOBTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
        }
    }

    //MARK: GENDER
    private func setupViewGenderTitleLabel() {
        self.scrollView.addSubview(self.genderTitleLabel)

        self.genderTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.DOBTitleLabel)
            make.left.equalTo(self.DOBLineDivider.snp.right).offset(Dimension.shared.largeVerticalMargin_60)
        }
    }

    private func setupViewMaleCheckBox() {
        self.scrollView.addSubview(self.maleCheckBox)

        self.maleCheckBox.snp.makeConstraints { (make) in
            make.width.height.equalTo(20 * Dimension.shared.heightScale)
            make.centerY.equalTo(self.DOBTextField)
            make.left.equalTo(self.genderTitleLabel)
        }
    }

    private func setupViewMaleTitleLabel() {
        self.scrollView.addSubview(self.maleTitleLabel)

        self.maleTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.maleCheckBox.snp.right).offset(Dimension.shared.smallHorizontalMargin)
            make.centerY.equalTo(self.maleCheckBox)
        }
    }

    private func setupViewFeMaleCheckBox() {
        self.scrollView.addSubview(self.femaleCheckBox)

        self.femaleCheckBox.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.maleCheckBox)
            make.centerY.equalTo(self.DOBTextField)
            make.left.equalTo(self.maleTitleLabel.snp.right).offset(27 * Dimension.shared.widthScale)
        }
    }

    private func setupViewFeMaleTitleLabel() {
        self.scrollView.addSubview(self.femaleTitleLabel)

        self.femaleTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.femaleCheckBox.snp.right).offset(Dimension.shared.smallHorizontalMargin)
            make.centerY.equalTo(self.maleCheckBox)
        }
    }

    //MARK: ADDRESS
    private func setupViewAddressTitleLabel() {
        self.scrollView.addSubview(self.addressTitleLabel)

        self.addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel)
            make.top.equalTo(self.DOBLineDivider).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewAddressTextfield() {
        self.scrollView.addSubview(self.addressTextField)

        self.addressTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTextField)
            make.width.equalTo(self.nameTextField)
            make.top.equalTo(self.addressTitleLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewAddressLineDivider() {
        self.scrollView.addSubview(self.addressLineDivider)

        self.addressLineDivider.snp.makeConstraints { (make) in
            make.height.equalTo(self.codeLineDivider)
            make.left.right.equalTo(self.nameLineDivider)
            make.top.equalTo(self.addressTextField.snp.bottom)
                .offset(Dimension.shared.smallHorizontalMargin)
        }
    }

    //MARK: - PHONE
    private func setupViewPhoneTitleLabel() {
        self.scrollView.addSubview(self.phoneTitleLabel)

        self.phoneTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel)
            make.top.equalTo(self.addressLineDivider.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewPhoneTextField() {
        self.scrollView.addSubview(self.phoneTextField)

        self.phoneTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.codeTextField)
            make.top.equalTo(self.phoneTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewPhoneLineDivider() {
        self.scrollView.addSubview(self.phoneLineDivider)

        self.phoneLineDivider.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.codeLineDivider)
            make.top.equalTo(self.phoneTextField.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
        }
    }

    //MARK: - EMAIL
    private func setupViewEmailTitleLabel() {
        self.scrollView.addSubview(self.emailTitleLabel)

        self.emailTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeTitleLabel)
            make.top.equalTo(self.phoneLineDivider.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewEmailTextField() {
        self.scrollView.addSubview(self.emailTextField)

        self.emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.codeTextField)
            make.top.equalTo(self.emailTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewEmailLineDivider() {
        self.scrollView.addSubview(self.emailLineDivider)

        self.emailLineDivider.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.codeLineDivider)
            make.top.equalTo(self.emailTextField.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
        }
    }

    private func setupViewNextButton() {
        self.scrollView.addSubview(self.nextButton)

        self.nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.emailLineDivider.snp.bottom).offset(Dimension.shared.largeVerticalMargin_32)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }

        self.nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

}

//MARK: - BEMCheckBoxDelegate
extension RegisterController: BEMCheckBoxDelegate {

    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox == self.maleCheckBox {
            self.patientRegister.setSexID(Gender.male)
        } else {
            self.patientRegister.setSexID(Gender.female)
        }
    }

}

//MARK: - UIPickerViewDelegate
extension RegisterController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30 * Dimension.shared.heightScale
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.addressTextField.text = self.listAddress[row].getDescription()
        self.patientRegister.setAddressID(self.listAddress[row].addressID)
        self.checkShowNextButton()
    }
}

//MARK: - UIPickerViewDataSource
extension RegisterController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listAddress.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()

        label.text = "\t \(self.listAddress[row].getDescription())"
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)

        return label
    }

}
