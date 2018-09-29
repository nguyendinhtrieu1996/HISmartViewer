//
//  EditAccountController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol EditAccountPatientControllerDelegate: class {
    func doneSaveData(_ patient: Patient)
}

class EditAccountPatientController: BaseViewController {

    var patient = Patient() {
        didSet {
            self.nameTextField.text = self.patient.patient_Name
            self.DOBTextField.text = self.patient.birth_Date.getDescription_DDMMYYYY_WithSlash()
            self.addressTextField.text = self.patient.address?.getDescription()
            self.phoneTextField.text = self.patient.mobile_Phone
            self.emailTextField.text = self.patient.email

            if self.patient.sex_ID == .male {
                self.maleCheckBox.on = true
                self.femaleCheckBox.on = false
            } else {
                self.femaleCheckBox.on = true
                self.maleCheckBox.on = false
            }
            
            self.patientBackingValue = self.patient.copy() as? Patient ?? Patient()
        }
    }
    
    weak var delegate: EditAccountPatientControllerDelegate?
    fileprivate var patientBackingValue = Patient()
    fileprivate var isAllowTapSaveButton = false
    fileprivate var listAddress = [Address]()

    enum TypeTextField: Int {
        case name = 0, DOB, address, phoneNumber, email
    }

    //MARK: UIControl
    private var scrollView = BaseScrollView()

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

        textfieldConfig.tag = 0
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

        textfieldConfig.tag = 1
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

        textfieldConfig.tag = 2
        textfieldConfig.placeholder = "Địa chỉ chỗ ở hiện tại (Số nhà, đường...)"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        textfieldConfig.inputView = self.addressPicker
        textfieldConfig.textAlignment = .left

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

        textfieldConfig.tag = 3
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

        textfieldConfig.tag = 4
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

    //MARK: Initialize
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewScrollView()
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

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
        
        self.addTargetForTextField()
        
        self.fetchData()
    }

    //MARK: Action UIControl
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func textFieldBeginEdit(_ textField: UITextField) {
        guard let type = TypeTextField(rawValue: textField.tag) else { return }

        switch type {
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
        let text = textField.text ?? ""

        switch type {
        case .name:
            self.patient.setPatientName(text)
            break
        case .phoneNumber:
            self.patient.setPhoneNumber(text)
            break
        case .email:
            self.patient.setEmail(text)
            break
        default:
            break
        }

        self.checkAllowTapSaveButton()
    }

    @objc func textFieldEndEdit(_ textField: UITextField) {
        guard let type = TypeTextField(rawValue: textField.tag) else { return }

        switch type {
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

    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        self.DOBTextField.text = dateFormatter.string(from: sender.date)
        self.patient.setBirthDate(sender.date)
        self.checkAllowTapSaveButton()
    }

    @objc func handleSaveButton() {
        if self.isAllowTapSaveButton {
            EditAccountFacade.UPDATE_Patient(self.patient, completionHanlder: {
                self.delegate?.doneSaveData(self.patient)
                let user = User.init(from: self.patient)
                Authentication.share.saveCurrentUserToUserDefault(user)
                HISMartManager.share.setCurrentPatient(self.patient)
                NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateInfoUser), object: nil)
                self.navigationController?.popViewController(animated: true)
            }, errorHandler: {
                //
            })
        }
    }

    //MARK: Feature
    fileprivate func checkAllowTapSaveButton() {
        if self.patient.isFillAllInfo() {
            if self.patient.isEqual(self.patientBackingValue) {
                self.addHideSaveItem()
                self.isAllowTapSaveButton = false
            } else {
                self.addShowSaveItem()
                self.isAllowTapSaveButton = true
            }
        } else {
            self.addHideSaveItem()
            self.isAllowTapSaveButton = false
        }
    }
    
    fileprivate func fetchData() {
        EditAccountFacade.GET_AllAddress { (listAddress) in
            self.listAddress = listAddress
            self.addressPicker.reloadAllComponents()
        }
    }
    
    private func addTargetForTextField() {
        //Touch Up Inside
        self.nameTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.DOBTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.addressTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.phoneTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.emailTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)

        //Value change
        self.nameTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.DOBTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.addressTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.phoneTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)

        //End editing
        self.nameTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.DOBTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.addressTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.phoneTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.emailTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
    }

    //MARK: SetupView function
    private func setupViewNavigationBar() {
        //BACK ITEM
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"), target: self, selector: #selector(handleBackButton), title: "Chỉnh sửa thông tin")

        //SAVE
        let image = UIImageView(image: UIImage.init(named: "SaveHideItem"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSaveButton))
        image.addGestureRecognizer(tapGesture)
        let imageItem = UIBarButtonItem.init(customView: image)
        self.navigationItem.rightBarButtonItem = imageItem
    }

    private func addHideSaveItem() {
        let image = UIImageView(image: UIImage.init(named: "SaveHideItem"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSaveButton))
        image.addGestureRecognizer(tapGesture)
        let imageItem = UIBarButtonItem.init(customView: image)
        self.navigationItem.rightBarButtonItem = imageItem
    }

    private func addShowSaveItem() {
        let image = UIImageView(image: UIImage.init(named: "SaveItemShow"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSaveButton))
        image.addGestureRecognizer(tapGesture)
        let imageItem = UIBarButtonItem.init(customView: image)
        self.navigationItem.rightBarButtonItem = imageItem
    }

    @objc private func setupViewScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.scrollView.view.snp.remakeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.view)
        }
    }

    //MARK: NAME
    private func setupViewNameTitleLabel() {
        self.scrollView.view.addSubview(self.nameTitleLabel)

        if #available(iOS 11, *) {
            self.nameTitleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(26 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
            }
        } else {
            self.nameTitleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(26 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin_32)
            }
        }
    }

    private func setupViewNameTextfiled() {
        self.scrollView.view.addSubview(self.nameTextField)

        self.nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel).offset(Dimension.shared.mediumHorizontalMargin)
            make.width.equalTo(self.view).offset(-Dimension.shared.largeHorizontalMargin_56)
            make.top.equalTo(self.nameTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewNameLineDivider() {
        self.scrollView.view.addSubview(self.nameLineDivider)

        self.nameLineDivider.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel)
            make.width.equalTo(self.view).offset(-2 * Dimension.shared.largeHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            make.top.equalTo(self.nameTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
        }
    }

    //MARK: DOB
    private func setupViewDOBTitleLabel() {
        self.scrollView.view.addSubview(self.DOBTitleLabel)

        self.DOBTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel)
            make.top.equalTo(self.nameLineDivider).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewDOBTextfiled() {
        self.scrollView.view.addSubview(self.DOBTextField)

        self.DOBTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTextField)
            make.width.equalTo(Dimension.shared.widthTextfieldDOB)
            make.top.equalTo(self.DOBTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewDropItemImage() {
        self.scrollView.view.addSubview(self.dropImage)

        self.dropImage.snp.makeConstraints { (make) in
            make.width.equalTo(10 * Dimension.shared.widthScale)
            make.height.equalTo(5 * Dimension.shared.heightScale)
            make.bottom.equalTo(self.DOBTextField).offset(-Dimension.shared.smallVerticalMargin)
            make.left.equalTo(self.DOBTextField.snp.right)
        }
    }

    private func setupViewDOBLineDivider() {
        self.scrollView.view.addSubview(self.DOBLineDivider)

        self.DOBLineDivider.snp.makeConstraints { (make) in
            make.left.height.equalTo(self.nameLineDivider)
            make.right.equalTo(self.dropImage).offset(Dimension.shared.smallHorizontalMargin)
            make.top.equalTo(self.DOBTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
        }
    }

    //MARK: GENDER
    private func setupViewGenderTitleLabel() {
        self.scrollView.view.addSubview(self.genderTitleLabel)

        self.genderTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.DOBTitleLabel)
            make.left.equalTo(self.DOBLineDivider.snp.right).offset(Dimension.shared.largeVerticalMargin_60)
        }
    }

    private func setupViewMaleCheckBox() {
        self.scrollView.view.addSubview(self.maleCheckBox)

        self.maleCheckBox.snp.makeConstraints { (make) in
            make.width.height.equalTo(20 * Dimension.shared.heightScale)
            make.centerY.equalTo(self.DOBTextField)
            make.left.equalTo(self.genderTitleLabel)
        }
    }

    private func setupViewMaleTitleLabel() {
        self.scrollView.view.addSubview(self.maleTitleLabel)

        self.maleTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.maleCheckBox.snp.right).offset(Dimension.shared.smallHorizontalMargin)
            make.centerY.equalTo(self.maleCheckBox)
        }
    }

    private func setupViewFeMaleCheckBox() {
        self.scrollView.view.addSubview(self.femaleCheckBox)

        self.femaleCheckBox.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.maleCheckBox)
            make.centerY.equalTo(self.DOBTextField)
            make.left.equalTo(self.maleTitleLabel.snp.right).offset(27 * Dimension.shared.widthScale)
        }
    }

    private func setupViewFeMaleTitleLabel() {
        self.scrollView.view.addSubview(self.femaleTitleLabel)

        self.femaleTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.femaleCheckBox.snp.right).offset(Dimension.shared.smallHorizontalMargin)
            make.centerY.equalTo(self.maleCheckBox)
        }
    }

    //MARK: ADDRESS
    private func setupViewAddressTitleLabel() {
        self.scrollView.view.addSubview(self.addressTitleLabel)

        self.addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel)
            make.top.equalTo(self.DOBLineDivider).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewAddressTextfield() {
        self.scrollView.view.addSubview(self.addressTextField)

        self.addressTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTextField)
            make.width.equalTo(self.nameTextField)
            make.top.equalTo(self.addressTitleLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewAddressLineDivider() {
        self.scrollView.view.addSubview(self.addressLineDivider)

        self.addressLineDivider.snp.makeConstraints { (make) in
            make.height.equalTo(self.nameLineDivider)
            make.left.right.equalTo(self.nameLineDivider)
            make.top.equalTo(self.addressTextField.snp.bottom)
                .offset(Dimension.shared.smallHorizontalMargin)
        }
    }

    //MARK: - PHONE
    private func setupViewPhoneTitleLabel() {
        self.scrollView.view.addSubview(self.phoneTitleLabel)

        self.phoneTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel)
            make.top.equalTo(self.addressLineDivider.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewPhoneTextField() {
        self.scrollView.view.addSubview(self.phoneTextField)

        self.phoneTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.nameTextField)
            make.top.equalTo(self.phoneTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewPhoneLineDivider() {
        self.scrollView.view.addSubview(self.phoneLineDivider)

        self.phoneLineDivider.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.nameLineDivider)
            make.top.equalTo(self.phoneTextField.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
        }
    }

    //MARK: - EMAIL
    private func setupViewEmailTitleLabel() {
        self.scrollView.view.addSubview(self.emailTitleLabel)

        self.emailTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel)
            make.top.equalTo(self.phoneLineDivider.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewEmailTextField() {
        self.scrollView.view.addSubview(self.emailTextField)

        self.emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.nameTextField)
            make.top.equalTo(self.emailTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewEmailLineDivider() {
        self.scrollView.view.addSubview(self.emailLineDivider)

        self.emailLineDivider.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.nameLineDivider)
            make.top.equalTo(self.emailTextField.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
    }

}

//MARK: - BEMCheckBoxDelegate
extension EditAccountPatientController: BEMCheckBoxDelegate {

    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox == self.maleCheckBox {
            self.femaleCheckBox.on = false
            self.patient.setSexID(.male)
        } else {
            self.patient.setSexID(.female)
            self.maleCheckBox.on = false
        }
        
        self.checkAllowTapSaveButton()
    }

}

//MARK: - UIPickerViewDelegate
extension EditAccountPatientController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30 * Dimension.shared.heightScale
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let address = self.listAddress[row]
        self.patient.setAddressID(address.addressID)
        self.patient.setAddress(address)
        self.addressTextField.text = address.getDescription()
        self.checkAllowTapSaveButton()
    }

}

//MARK: - UIPickerViewDataSource
extension EditAccountPatientController: UIPickerViewDataSource {

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














