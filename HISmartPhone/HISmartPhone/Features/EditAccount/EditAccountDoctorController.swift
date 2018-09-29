//
//  EditDocctorAccountController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/27/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol EditAccountDoctorControllerDelegate: class {
    func doneUpdateInfo(_ doctor: User)
}

class EditAccountDoctorController: BaseViewController {

    var doctor = User () {
        didSet {
            self.nameTextField.text = self.doctor.fullName
            self.phoneTextField.text = self.doctor.mobile_Phone
            
            if self.doctor.gender == .male {
                self.maleCheckBox.on = true
                self.femaleCheckBox.on = false
            } else {
                self.femaleCheckBox.on = true
                self.maleCheckBox.on = false
            }
            self.doctorBackingValue = doctor.copy() as? User ?? User()
        }
    }

    weak var delegate: EditAccountDoctorControllerDelegate?
    fileprivate var doctorBackingValue = User()
    fileprivate var isAllowTapSaveButton = false
    
    //MARK: UIControl
    private var scrollView = BaseScrollView()

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

        textfieldConfig.tag = 1
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

    //MARK: Initialize
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewScrollView()

        //NAME
        self.setupViewNameTitleLabel()
        self.setupViewNameTextfiled()
        self.setupViewNameLineDivider()

        //PHONE
        self.setupViewPhoneTitleLabel()
        self.setupViewPhoneTextField()
        self.setupViewPhoneLineDivider()

        //GENDER
        self.setupViewGenderTitleLabel()
        self.setupViewMaleCheckBox()
        self.setupViewMaleTitleLabel()
        self.setupViewFeMaleCheckBox()
        self.setupViewFeMaleTitleLabel()

        self.addTargetForTextField()
    }

    //MARK: Action
    @objc func handleSaveButton() {
        if self.isAllowTapSaveButton {
            EditAccountFacade.UPDATE_User(self.doctor, completionHanlder: {
                self.delegate?.doneUpdateInfo(self.doctor)
                Authentication.share.saveCurrentUserToUserDefault(self.doctor)
                NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateInfoUser), object: nil)
                self.navigationController?.popViewController(animated: true)
            }, errorHandler: {
                //
            })
        }
    }

    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func textFieldBeginEdit(_ textField: UITextField) {
        let tag = textField.tag
        
        if tag == 0 {
            self.nameLineDivider.backgroundColor = Theme.shared.primaryColor
        } else {
            self.phoneLineDivider.backgroundColor = Theme.shared.primaryColor
        }
    }

    @objc func textFieldValueChange(_ textField: UITextField) {
        let tag = textField.tag
        let text = textField.text ?? ""
        
        if tag == 0 {
            self.doctor.setName(text)
        } else {
            self.doctor.setMobilePhone(text)
        }
        
        self.checkIsAllowTapSaveItem()
    }

    @objc func textFieldEndEdit(_ textField: UITextField) {
        let tag = textField.tag
        
        if tag == 0 {
            self.nameLineDivider.backgroundColor = Theme.shared.lineDeviderColor
        } else {
            self.phoneLineDivider.backgroundColor = Theme.shared.lineDeviderColor
        }
    }

    //MARK: Feature
    private func checkIsAllowTapSaveItem(){
        if self.doctor.isFillAllData() {
            if self.doctor.isEqual(self.doctorBackingValue) {
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
    
    private func addTargetForTextField() {
        //Touch Up Inside
        self.nameTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)
        self.phoneTextField.addTarget(self, action: #selector(textFieldBeginEdit(_:)), for: .editingDidBegin)

        //Value change
        self.nameTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        self.phoneTextField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)

        //End editing
        self.nameTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.phoneTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
    }

    //MARK: SetupView
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

        self.navigationItem.addRightBarItems(with: "LƯU",
                                             target: self,
                                             selector: #selector(handleSaveButton))
    }

    func setupViewScrollView() {
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
            make.top.equalTo(self.nameTitleLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewNameLineDivider() {
        self.scrollView.view.addSubview(self.nameLineDivider)

        self.nameLineDivider.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel)
            make.width.equalTo(self.view).offset(-2 * Dimension.shared.largeHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            make.top.equalTo(self.nameTextField.snp.bottom)
                .offset(Dimension.shared.smallHorizontalMargin)
        }
    }
    //MARK: PHONE
    private func setupViewPhoneTitleLabel() {
        self.scrollView.view.addSubview(self.phoneTitleLabel)

        self.phoneTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTitleLabel)
            make.top.equalTo(self.nameLineDivider).offset(Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewPhoneTextField() {
        self.scrollView.view.addSubview(self.phoneTextField)

        self.phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameTextField)
            make.width.equalTo(140 * Dimension.shared.widthScale)
            make.top.equalTo(self.phoneTitleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }

    private func setupViewPhoneLineDivider() {
        self.scrollView.view.addSubview(self.phoneLineDivider)

        self.phoneLineDivider.snp.makeConstraints { (make) in
            make.left.height.equalTo(self.nameLineDivider)
            make.right.equalTo(self.phoneTextField).offset(Dimension.shared.smallHorizontalMargin)
            make.top.equalTo(self.phoneTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
        }
    }

    //MARK: GENDER
    private func setupViewGenderTitleLabel() {
        self.scrollView.view.addSubview(self.genderTitleLabel)

        self.genderTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneTitleLabel)
            make.left.equalTo(self.phoneLineDivider.snp.right)
                .offset(Dimension.shared.largeVerticalMargin_32)
        }
    }

    private func setupViewMaleCheckBox() {
        self.scrollView.view.addSubview(self.maleCheckBox)

        self.maleCheckBox.snp.makeConstraints { (make) in
            make.width.height.equalTo(20 * Dimension.shared.heightScale)
            make.centerY.equalTo(self.phoneTextField)
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
            make.centerY.equalTo(self.maleCheckBox)
            make.left.equalTo(self.maleTitleLabel.snp.right).offset(27 * Dimension.shared.widthScale)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
    }

    private func setupViewFeMaleTitleLabel() {
        self.scrollView.view.addSubview(self.femaleTitleLabel)

        self.femaleTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.femaleCheckBox.snp.right).offset(Dimension.shared.smallHorizontalMargin)
            make.centerY.equalTo(self.maleCheckBox)
        }
    }

}

//MARK: - BEMCheckBoxDelegate
extension EditAccountDoctorController: BEMCheckBoxDelegate {

    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox == self.maleCheckBox {
            self.doctor.setGender(.male)
            self.femaleCheckBox.on = false
        } else {
            self.doctor.setGender( .female)
            self.maleCheckBox.on = true
        }
        
        self.checkIsAllowTapSaveItem()
    }

}









