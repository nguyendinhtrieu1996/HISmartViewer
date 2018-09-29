//
//  AddNewPrescriptionCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/27/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol AddNewPrescriptionCellDelegate: class {
    func didSelectListDrugButton()
}

class AddNewPrescriptionCell: BaseCollectionViewCell {
    
    //MARK: Variable
    weak var delegate: AddNewPrescriptionCellDelegate?
    fileprivate let quantityData: [Int] = [8, 7, 6, 5, 4, 3, 2, 1]
    fileprivate let unitData: [String] = ["Vỉ", "Tuýp", "Hộp", "Viên"]
    fileprivate var indexQuantitySelected: Int?
    fileprivate var indexUnitSelected: Int?
    
    //MARK: UIControl
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
    
    private let addButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "add_box_gray"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    private let listDrugButton: ButtonWidthImage = {
        let button = ButtonWidthImage(title: "Danh sách thuốc",
                                      image: "arrow_down",
                                      widthImage: 10 * Dimension.shared.widthScale,
                                      fontSize: Dimension.shared.bodyFontSize)
        
        button.backgroundColor = Theme.shared.accentColor
        button.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        button.layer.masksToBounds = true
        
        return button
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
    override func setupView() {
        self.scrollView.isUserInteractionEnabled = true
        
        self.setupViewAddButton()
        
        self.setupViewContaintView()
        self.setupViewScrollView()
        
        self.setupViewNameLabel()
        self.setupViewNameTextField()
        self.setupViewNameLineDevider()
        
        self.setupViewQuantityLabel()
        self.setupViewQuantityTextField()
        self.setupViewQuantityLineDevider()
        self.setupViewDropImage()
        
        self.setupViewGuideLabel()
        self.setupViewGuideTextField()
        self.setupViewGuideLineDevider()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.setupViewListDrugButton()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotateDevice), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    //MARK: Handle Action
    @objc func handleListDrugButton() {
        self.delegate?.didSelectListDrugButton()
    }
    
    @objc func handleRotateDevice() {
        if UIDevice.current.orientation.isPortrait {
            self.scrollView.isScrollEnabled = false
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: self.frame.height)
        } else {
            self.scrollView.isScrollEnabled = true
            let height = self.frame.height + 55 * Dimension.shared.heightScale
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: height)
        }
    }
    
    @objc func handleScrollView() {
        self.quantityDrugTextField.endEditing(true)
    }
    
    //MARK: Feature
    
    //MARK: SetupView
    private func setupViewContaintView() {
        self.addSubview(self.containtScrollView)
        
        self.containtScrollView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.addButton.snp.bottom)
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
                                                 height: self.frame.height)
        } else {
            self.scrollView.isScrollEnabled = true
            let height = self.frame.height + 55 * Dimension.shared.heightScale
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                                 height: height)
        }
    }
    
    private func setupViewAddButton() {
        self.addSubview(self.addButton)
        
        self.addButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20 * Dimension.shared.heightScale)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewListDrugButton() {
        self.scrollView.addSubview(self.listDrugButton)
        
        self.listDrugButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
                .offset(self.containtScrollView.frame.height / 2 - Dimension.shared.defaultHeightButton - Dimension.shared.normalVerticalMargin )
        }
        
        self.listDrugButton.addTarget(self, action: #selector(handleListDrugButton), for: .touchUpInside)
    }
    
    //NAME
    private func setupViewNameLabel() {
        self.scrollView.addSubview(self.nameDrugLabel)
        
        self.nameDrugLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
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
            make.top.equalTo(self.nameDrugTextField.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    //QUANTITY
    private func setupViewQuantityLabel() {
        self.scrollView.addSubview(self.quantityDrugLabel)
        
        self.quantityDrugLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameDrugLabel)
            make.top.equalTo(self.nameDrugLineDivider.snp.bottom).offset(Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupViewQuantityTextField() {
        self.scrollView.addSubview(self.quantityDrugTextField)
        
        self.quantityDrugTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameDrugTextField)
            make.width.equalTo(110 * Dimension.shared.widthScale)
            make.top.equalTo(self.quantityDrugLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
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
            make.left.equalTo(self.quantityDrugTextField.snp.right).offset(Dimension.shared.smallHorizontalMargin)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleScrollView))
        self.scrollView.addGestureRecognizer(tapGesture)
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
            make.top.equalTo(self.guideDrugLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewGuideLineDevider() {
        self.scrollView.addSubview(self.guideDrugLineDivider)
        
        self.guideDrugLineDivider.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.nameDrugLineDivider)
            make.top.equalTo(self.guideDrugTextField.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
        }
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddNewPrescriptionCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.quantityData.count
        } else {
            return self.unitData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        label.textAlignment = .center
        
        if component == 0 {
            label.text = "\(self.quantityData[row])"
            
            return label
        } else {
            label.text = "\(self.unitData[row])"
            
            return label
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30 * Dimension.shared.heightScale
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var content  = ""
        
        if component == 0 {
            content += "\(self.quantityData[row])"
        } else {
            content += " \(self.unitData[row])"
        }
        
        self.quantityDrugTextField.text = content
    }
    
}




