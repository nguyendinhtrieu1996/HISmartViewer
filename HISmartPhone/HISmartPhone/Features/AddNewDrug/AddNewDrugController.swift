//
//  AddNewDrugController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/28/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol AddNewDrugControllerDelegate: class {
    func didEndEditPrescription(_ prescription: Prescription)
}

class AddNewDrugController: BaseViewController {
    
    //MARK: Variable
    fileprivate let quantityData: [Int] = [0, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
    fileprivate var isUploading = false
    fileprivate var isAllowTapSaveButton = true
    
    weak var delegate: AddNewDrugControllerDelegate?

    enum TypeTextField: Int {
        case name = 0
        case quantity = 1
        case guide = 2
        case dateApply = 3
        case code
    }
    
    var titleText: String? {
        didSet {
            self.titleLabel.text = titleText
        }
    }
    
    var isEditPrescription: Bool = false {
        didSet {
            self.prescriptionBackingValue = self.prescription.copy() as? Prescription ?? Prescription()
        }
    }
    
    var prescription: Prescription = Prescription() {
        didSet {
            self.codeTextField.text = self.prescription.prescriptionCode
            self.nameDrugTextField.text = self.prescription.prescriptionName
            self.quantityDrugTextField.text = self.prescription.prescriptionQuantity.description
            self.dateApplyTextField.text = self.prescription.dateApply
            self.guideDrugTextField.text = self.prescription.comment
        }
    }
    
    private var prescriptionBackingValue = Prescription()
    
    //MARK: UIControl
    private let contentTitleView: UIView = {
        let viewConfig = UIView()
        
        viewConfig.backgroundColor = Theme.shared.primaryColor
        viewConfig.makeShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 1.0, radius: 4.0)
        
        return viewConfig
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Thêm thuốc"
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let containtScrollView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    fileprivate lazy var quantityPicker: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = Theme.shared.pickerBackgroundColor
        
        return picker
    }()
    
    //CODE
    private let codeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Mã đơn thuốc"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private lazy var codeTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 4
        textfieldConfig.placeholder = "Nhập mã đơn thuốc"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let codeLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //NAME
    private let nameDrugLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Tên thuốc"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private lazy var nameDrugTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 0
        textfieldConfig.placeholder = "Nhập tên thuốc"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let nameDrugLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //QUANTITY
    private let quantityDrugLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Số lượng"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private lazy var quantityDrugTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 1
        textfieldConfig.placeholder = "Chọn số lượng"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        textfieldConfig.inputView = self.quantityPicker
        
        
        return textfieldConfig
    }()
    
    private var dropImage: UIImageView = {
        let imageConfig = UIImageView()
        
        imageConfig.image = UIImage(named: "Drop_item")
        imageConfig.contentMode = .scaleAspectFill
        
        return imageConfig
    }()
    
    private let quantityDrugLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //DATE APPLY
    private let dateApplyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "DateApply"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private lazy var dateApplyTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 3
        textfieldConfig.placeholder = "DateApply"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    
    private let dateApplyLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //GUIDE
    private let guideDrugLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Hướng dẫn"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private lazy var guideDrugTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.tag = 2
        textfieldConfig.placeholder = "Nhập hướng dẫn"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        
        return textfieldConfig
    }()
    
    private let guideDrugLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    //MARK: Initialize
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func setupView() {
        self.scrollView.isUserInteractionEnabled = true
        self.setupViewNavigationBar()
        self.setupViewContaintTitleView()
        self.setupViewTitleLabel()
        self.setupViewContaintView()
        self.setupViewScrollView()
        
        //CODE
        self.setupViewCodeLabel()
        self.setupViewCodeTextField()
        self.setupViewCodeLineDevider()
        
        //NAME
        self.setupViewNameLabel()
        self.setupViewNameTextField()
        self.setupViewNameLineDevider()
        
        //QUANTITY
        self.setupViewQuantityLabel()
        self.setupViewQuantityTextField()
        self.setupViewQuantityLineDevider()
        self.setupViewDropImage()
        
        //DATE APPLY
        self.setupViewDateApplyLabel()
        self.setupViewDateApplyTextField()
        self.setupViewDateApplyLineDevider()
        
        //GUIDE
        self.setupViewGuideLabel()
        self.setupViewGuideTextField()
        self.setupViewGuideLineDevider()
        
        self.addTargetForTextfield()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotateDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    //MARK: Handle UIControl
    @objc func handleCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveButton() {
        if self.isAllowTapSaveButton {
            self.view.endEditing(true)
            
            if !self.isUploading {
                self.isUploading = true
                self.nameDrugTextField.isUserInteractionEnabled = false
                self.quantityDrugTextField.isUserInteractionEnabled = false
                self.guideDrugTextField.isUserInteractionEnabled = false
                
                AddNewDrugFacade.postPrescription(prescription: self.prescription, completionHandler: {
                    NotificationCenter.default.post(name:
                        NSNotification.Name.init(Notification.Name.updateListPrescription), object: nil)
                    
                    self.delegate?.didEndEditPrescription(self.prescription)
                    self.navigationController?.popViewController(animated: true)
                }, errorHandler: {
                    self.isUploading = false
                    self.nameDrugTextField.isUserInteractionEnabled = true
                    self.quantityDrugTextField.isUserInteractionEnabled = true
                    self.guideDrugTextField.isUserInteractionEnabled = true
                })
            } else {
                //Is Uploading
            }
        } else {
            //
        }
    }
    
    @objc func handleRotateDevice() {
        if UIDevice.current.orientation.isPortrait {
            self.scrollView.isScrollEnabled = false
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: self.view.frame.height)
        } else {
            self.scrollView.isScrollEnabled = true
            let height = self.view.frame.height + 55 * Dimension.shared.heightScale
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: height)
        }
    }
    
    @objc func textFieldBegginEdit(_ textfield: UITextField) {
        let typeTextfield = TypeTextField.init(rawValue: textfield.tag) ?? .name
        
        switch typeTextfield {
        case .name:
            self.nameDrugLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .quantity:
            self.quantityDrugLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .guide:
            self.guideDrugLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .dateApply:
            self.dateApplyLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        case .code:
            self.codeLineDivider.backgroundColor = Theme.shared.primaryColor
            break
        }
    }
    
    @objc func textFieldValueChangeEdit(_ textfield: UITextField) {
        let typeTextfield = TypeTextField.init(rawValue: textfield.tag) ?? .name
        guard let text = textfield.text else { return }
        
        switch typeTextfield {
        case .name:
            self.prescription.setName(text)
            break
        case .quantity:
            break
        case .guide:
            self.prescription.setComment(text)
            break
        case .dateApply:
            self.prescription.setDateApplye(text)
            break
        case .code:
            self.prescription.setCode(text)
            break
        }
        
    }
    
    @objc func textFieldEndEdit(_ textfield: UITextField) {
        let typeTextfield = TypeTextField.init(rawValue: textfield.tag) ?? .name
        
        switch typeTextfield {
        case .name:
            self.nameDrugLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .quantity:
            self.quantityDrugLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .guide:
            self.guideDrugLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .dateApply:
            self.dateApplyLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        case .code:
            self.codeLineDivider.backgroundColor = Theme.shared.lineDeviderColor
            break
        }
    }
    
    @objc func handleScrollView() {
        self.quantityDrugTextField.endEditing(true)
    }
    
    //MARK: Feature
    private func checkAllowTapSaveButton() {
        if self.prescription.isFillAllData() {
            if self.isEditPrescription {
                if self.prescription.equal(with: self.prescriptionBackingValue) {
                    self.addHideSaveItem()
                    self.isAllowTapSaveButton = false
                } else {
                    self.addShowSaveItem()
                    self.isAllowTapSaveButton = true
                }
            } else {
                self.addShowSaveItem()
                self.isAllowTapSaveButton = true
            }
        } else {
            self.addHideSaveItem()
            self.isAllowTapSaveButton = false
        }
    }
    
    private func addTargetForTextfield() {
        //BEGIN
        self.nameDrugTextField.addTarget(self, action: #selector(textFieldBegginEdit(_:)), for: .editingDidBegin)
        self.quantityDrugTextField.addTarget(self, action: #selector(textFieldBegginEdit(_:)), for: .editingDidBegin)
        self.guideDrugTextField.addTarget(self, action: #selector(textFieldBegginEdit(_:)), for: .editingDidBegin)
        self.dateApplyTextField.addTarget(self, action: #selector(textFieldBegginEdit(_:)), for: .editingDidBegin)
        self.codeTextField.addTarget(self, action: #selector(textFieldBegginEdit(_:)), for: .editingDidBegin)
        
        //VALUE CHANGE
        self.nameDrugTextField.addTarget(self, action: #selector(textFieldValueChangeEdit(_:)), for: .editingChanged)
        self.quantityDrugTextField.addTarget(self, action: #selector(textFieldValueChangeEdit(_:)), for: .editingChanged)
        self.guideDrugTextField.addTarget(self, action: #selector(textFieldValueChangeEdit(_:)), for: .editingChanged)
        self.dateApplyTextField.addTarget(self, action: #selector(textFieldValueChangeEdit(_:)), for: .editingChanged)
        self.codeTextField.addTarget(self, action: #selector(textFieldValueChangeEdit(_:)), for: .editingChanged)
        
        //BEGIN
        self.nameDrugTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.quantityDrugTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.guideDrugTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.dateApplyTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
        self.codeTextField.addTarget(self, action: #selector(textFieldEndEdit(_:)), for: .editingDidEnd)
    }
    
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        //CLOSE
        self.navigationItem.addLeftBarItem(with: UIImage(named: "clear_white"), target: self, selector: #selector(handleCloseButton), title: nil)
        
        //SAVE
        self.addShowSaveItem()
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
    
    private func setupViewContaintTitleView() {
        self.view.addSubview(self.contentTitleView)
        
        if #available(iOS 11, *) {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightExtendNavigationBar)
                make.top.equalTo(self.view.safeAreaInsets)
            }
        } else {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightExtendNavigationBar)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func setupViewTitleLabel() {
        self.contentTitleView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.top.equalToSuperview()
        }
    }
    
    private func setupViewDateLabel() {
        self.contentTitleView.addSubview(self.dateLabel)
        
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewContaintView() {
        self.view.addSubview(self.containtScrollView)
        
        self.containtScrollView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.contentTitleView.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupViewScrollView() {
        self.containtScrollView.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.containtScrollView)
        }
        
        if UIDevice.current.orientation.isPortrait {
            self.scrollView.isScrollEnabled = false
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: self.view.frame.height)
        } else {
            self.scrollView.isScrollEnabled = true
            let height = self.view.frame.height + 55 * Dimension.shared.heightScale
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: height)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleScrollView))
        self.scrollView.addGestureRecognizer(tapGesture)
    }
    
    //CODE
    private func setupViewCodeLabel() {
        self.scrollView.addSubview(self.codeLabel)
        
        if #available(iOS 11, *) {
            self.codeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            }
        } else {
            self.codeLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            }
        }
    }
    
    private func setupViewCodeTextField() {
        self.scrollView.addSubview(self.codeTextField)
        
        self.codeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeLabel).offset(Dimension.shared.smallHorizontalMargin)
            make.width.equalTo(315 * Dimension.shared.widthScale)
            make.top.equalTo(self.codeLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewCodeLineDevider() {
        self.scrollView.addSubview(self.codeLineDivider)
        
        self.codeLineDivider.snp.makeConstraints { (make) in
            make.left.equalTo(self.codeLabel)
            make.right.equalTo(self.codeTextField).offset(Dimension.shared.mediumHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            make.top.equalTo(self.codeTextField.snp.bottom)
                .offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    //NAME
    private func setupViewNameLabel() {
        self.scrollView.addSubview(self.nameDrugLabel)
        
        if #available(iOS 11, *) {
            self.nameDrugLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.codeLineDivider.snp.bottom)
                    .offset(Dimension.shared.largeVerticalMargin)
            }
        } else {
            self.nameDrugLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.codeLineDivider.snp.bottom)
                    .offset(Dimension.shared.largeVerticalMargin)
            }
        }
    }
    
    private func setupViewNameTextField() {
        self.scrollView.addSubview(self.nameDrugTextField)
        
        self.nameDrugTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameDrugLabel).offset(Dimension.shared.smallHorizontalMargin)
            make.width.equalTo(315 * Dimension.shared.widthScale)
            make.top.equalTo(self.nameDrugLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewNameLineDevider() {
        self.scrollView.addSubview(self.nameDrugLineDivider)
        
        self.nameDrugLineDivider.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameDrugLabel)
            make.right.equalTo(self.nameDrugTextField).offset(Dimension.shared.mediumHorizontalMargin)
            make.height.equalTo(Dimension.shared.heightLineDivider)
            make.top.equalTo(self.nameDrugTextField.snp.bottom)
                .offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    //QUANTITY
    private func setupViewQuantityLabel() {
        self.scrollView.addSubview(self.quantityDrugLabel)
        
        self.quantityDrugLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameDrugLabel)
            make.top.equalTo(self.nameDrugLineDivider.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupViewQuantityTextField() {
        self.scrollView.addSubview(self.quantityDrugTextField)
        
        self.quantityDrugTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameDrugTextField)
            make.width.equalTo(110 * Dimension.shared.widthScale)
            make.top.equalTo(self.quantityDrugLabel.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewQuantityLineDevider() {
        self.scrollView.addSubview(self.quantityDrugLineDivider)
        
        self.quantityDrugLineDivider.snp.makeConstraints { (make) in
            make.left.height.equalTo(self.nameDrugLineDivider)
            make.right.equalTo(self.quantityDrugTextField).offset(Dimension.shared.largeVerticalMargin)
            make.top.equalTo(self.quantityDrugTextField.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewDropImage() {
        self.scrollView.addSubview(self.dropImage)
        
        self.dropImage.snp.makeConstraints { (make) in
            make.width.equalTo(10 * Dimension.shared.widthScale)
            make.height.equalTo(5 * Dimension.shared.heightScale)
            make.bottom.equalTo(self.quantityDrugTextField).offset(-Dimension.shared.smallVerticalMargin)
            make.left.equalTo(self.quantityDrugTextField.snp.right)
                .offset(Dimension.shared.smallHorizontalMargin)
        }
    }
    
    //MARK: DATE APPLY
    private func setupViewDateApplyLabel() {
        self.scrollView.addSubview(self.dateApplyLabel)
        
        self.dateApplyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.quantityDrugLabel)
            make.left.equalTo(self.quantityDrugLineDivider.snp.right)
                .offset(Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupViewDateApplyTextField() {
        self.scrollView.addSubview(self.dateApplyTextField)
        
        self.dateApplyTextField.snp.makeConstraints { (make) in
            make.width.centerY.height.equalTo(self.quantityDrugTextField)
            make.left.equalTo(self.dateApplyLabel).offset(Dimension.shared.smallHorizontalMargin)
        }
    }
    
    private func setupViewDateApplyLineDevider() {
        self.scrollView.addSubview(self.dateApplyLineDivider)
        
        self.dateApplyLineDivider.snp.makeConstraints { (make) in
            make.height.equalTo(self.nameDrugLineDivider)
            make.left.equalTo(self.dateApplyLabel)
            make.right.equalTo(self.dateApplyTextField).offset(Dimension.shared.smallHorizontalMargin)
            make.top.equalTo(self.quantityDrugTextField.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    //GUIDE
    private func setupViewGuideLabel() {
        self.scrollView.addSubview(self.guideDrugLabel)
        
        self.guideDrugLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameDrugLabel)
            make.top.equalTo(self.quantityDrugLineDivider.snp.bottom)
                .offset(Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupViewGuideTextField() {
        self.scrollView.addSubview(self.guideDrugTextField)
        
        self.guideDrugTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.nameDrugTextField)
            make.top.equalTo(self.guideDrugLabel.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewGuideLineDevider() {
        self.scrollView.addSubview(self.guideDrugLineDivider)
        
        self.guideDrugLineDivider.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.nameDrugLineDivider)
            make.top.equalTo(self.guideDrugTextField.snp.bottom)
                .offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddNewDrugController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.quantityData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let text = self.quantityData[row] == 0 ? "" : self.quantityData[row].description
        let label = UILabel()
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        label.textAlignment = .center
        label.text = text
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30 * Dimension.shared.heightScale
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.prescription.setQuanitty(self.quantityData[row])
        self.quantityDrugTextField.text = self.quantityData[row] == 0 ? "" : self.quantityData[row].description
    }
    
}



