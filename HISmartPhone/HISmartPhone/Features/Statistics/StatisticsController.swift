//
//  StatisticsController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/23/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class StatisticsController: BaseInfoPatientVC {
    
    //MARK: Variable
    fileprivate var isSelectFromDate = true
    fileprivate var fromDate: Date?
    fileprivate var toDate: Date?
    fileprivate var BPOFromToDate = BPOFromToDateManager()
    
    //MARK: UIControl
    private let noneDataMessage: UILabel = {
        let label = UILabel()
        
        label.text = "Không có kết quả huyết áp nào"
        label.textColor = Theme.shared.darkBlueTextColor
        label.textAlignment = .center
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    fileprivate let datePicker: UIDatePicker = {
        let datePickerConfig = UIDatePicker()
        
        datePickerConfig.datePickerMode = .date
        datePickerConfig.locale = Locale(identifier: "vi-VN")
        datePickerConfig.maximumDate = Date()
        
        return datePickerConfig
    }()
    
    fileprivate let betterSegment: BetterSegmentedControl = {
        let titles = ["Đồ thị thống kê", "Đồ thị Pie"]
        let options: [BetterSegmentedControlOption] =
            [.backgroundColor(Theme.shared.primaryColor),
             BetterSegmentedControlOption.cornerRadius(Dimension.shared.heightCustomSegment / 2),
             BetterSegmentedControlOption.indicatorViewBackgroundColor(Theme.shared.defaultBGColor),
             BetterSegmentedControlOption.titleFont(UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)),
             BetterSegmentedControlOption.titleColor(Theme.shared.defaultTextColor),
             BetterSegmentedControlOption.selectedTitleFont(UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)),
             BetterSegmentedControlOption.selectedTitleColor(Theme.shared.primaryColor)]
        
        let segment = BetterSegmentedControl(frame: .zero, titles: titles, index: 0, options: options)
        segment.addTarget(self, action: #selector(handleSegmentControl(_:)), for: .valueChanged)
        
        return segment
    }()
    
    //MARK: FROM TO DATE
    private let fromLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Từ"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Đến"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private lazy var fromTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "dd/MM/yyyy"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        textfieldConfig.inputView = self.datePicker
        
        return textfieldConfig
    }()
    
    private var fromDropImage: UIImageView = {
        let imageConfig = UIImageView()
        
        imageConfig.image = UIImage(named: "Drop_item")
        imageConfig.contentMode = .scaleAspectFill
        
        return imageConfig
    }()
    
    private let fromLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    private lazy var toTextField: UITextField = {
        let textfieldConfig = UITextField()
        
        textfieldConfig.placeholder = "dd/MM/yyyy"
        textfieldConfig.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        textfieldConfig.textColor = Theme.shared.primaryColor
        textfieldConfig.inputView = self.datePicker
        
        return textfieldConfig
    }()
    
    private var toDropImage: UIImageView = {
        let imageConfig = UIImageView()
        
        imageConfig.image = UIImage(named: "Drop_item")
        imageConfig.contentMode = .scaleAspectFill
        
        return imageConfig
    }()
    
    private let toLineDivider: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.lineDeviderColor
        return viewConfig
    }()
    
    fileprivate lazy var chartCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Theme.shared.defaultBGColor
        collectionView.register(StatisticalCell.self, forCellWithReuseIdentifier: StatisticalCell.identifier)
        collectionView.register(PIECell.self, forCellWithReuseIdentifier: PIECell.identifier)
        
        return collectionView
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        self.setupViewFromTextfiled()
        self.setupViewFromDropItemImage()
        self.setupViewFromLineDivider()
        self.setupViewFromLabel()

        self.setupViewToTextfiled()
        self.setupViewToDropItemImage()
        self.setupViewToLineDivider()
        self.setupViewToLabel()

        self.setupViewCustomSegment()
        self.setupViewCollectionView()

        self.setupViewNoneDataLabel()

        NotificationCenter.default.addObserver(self, selector: #selector(scrollCollectionView), name: NSNotification.Name.init(Notification.Name.UIDeviceOrientationDidChange.rawValue), object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Handle Action
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.chartCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func scrollCollectionView() {
        if betterSegment.index == 0 {
            self.chartCollectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            self.chartCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    @objc func superViewTapped() {
        self.view.endEditing(true)
    }
    
    @objc func handleSegmentControl(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            self.chartCollectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        } else {
            self.chartCollectionView.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    @objc func fromTextFieldBeginEdit() {
        let toDate: Date? = self.toDate != nil ? self.toDate : Date()
        self.datePicker.maximumDate = toDate
        self.datePicker.minimumDate = nil
        self.isSelectFromDate = true
        self.fromLineDivider.backgroundColor = Theme.shared.primaryColor
    }
    
    @objc func fromTextFieldEndEdit() {
        if self.fromDate == nil {
            self.fromDate = self.datePicker.date
            self.fromTextField.text = self.fromDate?.getDescription_DDMMYYYY_WithSlash()
        }
        
        self.isSelectFromDate = true
        self.fromLineDivider.backgroundColor = Theme.shared.lineDeviderColor
        self.fetchData()
    }
    
    @objc func toTextFieldBeginEdit() {
        let fromDate: Date? = self.fromDate != nil ? self.fromDate : Date()
        self.datePicker.minimumDate = fromDate
        self.datePicker.maximumDate = Date()
        self.isSelectFromDate = false
        self.toLineDivider.backgroundColor = Theme.shared.primaryColor
    }
    
    @objc func toTextFieldEndEdit() {
        if self.toDate == nil {
            self.toDate = self.datePicker.date
            self.toTextField.text = self.toDate?.getDescription_DDMMYYYY_WithSlash()
        }
        
        self.isSelectFromDate = false
        self.toLineDivider.backgroundColor = Theme.shared.lineDeviderColor
        self.fetchData()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if self.isSelectFromDate {
            self.fromDate = sender.date
            self.fromTextField.text = sender.date.getDescription_DDMMYYYY_WithSlash()
        } else {
            self.toDate = sender.date
            self.toTextField.text = sender.date.getDescription_DDMMYYYY_WithSlash()
        }
    }
    
    //MARK: Feature
    private func fetchData() {
        guard let fromDate = self.fromDate else { return }
        guard let toDate = self.toDate else { return }
        
        StatictisFacade.fetchBloodPressures(fromDate, toDate) { (BPOFromToDate) in
            self.BPOFromToDate = BPOFromToDate
            self.chartCollectionView.reloadData()
            
            if BPOFromToDate.BPOResults.isEmpty {
                self.chartCollectionView.isHidden = true
                self.noneDataMessage.isHidden = false
            } else {
                self.chartCollectionView.isHidden = false
                self.noneDataMessage.isHidden = true
            }
        }
    }
    
    //MARK: SetupView
    
    //MARK: FROM
    private func setupViewFromTextfiled() {
        self.view.addSubview(self.fromTextField)
        
        if #available(iOS 11, *) {
            self.fromTextField.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(Dimension.shared.widthFROMANDTOTextField)
                make.height.equalTo(Dimension.shared.defaultHeightTextField)
                make.top.equalTo(self.view.safeAreaInsets)
                    .offset(2.5 * Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.fromTextField.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(Dimension.shared.widthFROMANDTOTextField)
                make.height.equalTo(Dimension.shared.defaultHeightTextField)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                    .offset(2.5 * Dimension.shared.normalVerticalMargin)
            }
        }
        
        self.fromTextField.addTarget(self, action: #selector(fromTextFieldBeginEdit), for: .editingDidBegin)
        self.fromTextField.addTarget(self, action: #selector(fromTextFieldEndEdit), for: .editingDidEnd)
    }
    
    private func setupViewFromDropItemImage() {
        self.view.addSubview(self.fromDropImage)
        
        self.fromDropImage.snp.makeConstraints { (make) in
            make.width.equalTo(10 * Dimension.shared.widthScale)
            make.height.equalTo(5 * Dimension.shared.heightScale)
            make.bottom.equalTo(self.fromTextField).offset(-Dimension.shared.smallVerticalMargin)
            make.left.equalTo(self.fromTextField.snp.right)
        }
    }
    
    private func setupViewFromLineDivider() {
        self.view.addSubview(self.fromLineDivider)
        
        self.fromLineDivider.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.heightLineDivider)
            make.left.equalTo(self.fromTextField).offset(-Dimension.shared.smallHorizontalMargin)
            make.right.equalTo(self.fromDropImage).offset(Dimension.shared.smallHorizontalMargin)
            make.top.equalTo(self.fromTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
        }
    }
    
    private func setupViewFromLabel() {
        self.view.addSubview(self.fromLabel)
        
        self.fromLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.fromTextField)
            make.bottom.equalTo(self.fromTextField.snp.top).offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
    
    //MARK: TO
    private func setupViewToTextfiled() {
        self.view.addSubview(self.toTextField)
        
        if #available(iOS 11, *) {
            self.toTextField.snp.makeConstraints { (make) in
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(self.fromTextField)
                make.height.equalTo(Dimension.shared.defaultHeightTextField)
                make.top.equalTo(self.fromTextField)
            }
        } else {
            self.toTextField.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(self.fromTextField)
                make.height.equalTo(Dimension.shared.defaultHeightTextField)
                make.top.equalTo(self.fromTextField)
            }
        }
        
        self.toTextField.addTarget(self, action: #selector(toTextFieldBeginEdit), for: .editingDidBegin)
        self.toTextField.addTarget(self, action: #selector(toTextFieldEndEdit), for: .editingDidEnd)
    }
    
    private func setupViewToDropItemImage() {
        self.view.addSubview(self.toDropImage)
        
        self.toDropImage.snp.makeConstraints { (make) in
            make.width.equalTo(10 * Dimension.shared.widthScale)
            make.height.equalTo(5 * Dimension.shared.heightScale)
            make.bottom.equalTo(self.toTextField).offset(-Dimension.shared.smallVerticalMargin)
            make.left.equalTo(self.toTextField.snp.right)
        }
    }
    
    private func setupViewToLineDivider() {
        self.view.addSubview(self.toLineDivider)
        
        self.toLineDivider.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.heightLineDivider)
            make.left.equalTo(self.toTextField).offset(-Dimension.shared.smallHorizontalMargin)
            make.right.equalTo(self.toDropImage).offset(Dimension.shared.smallHorizontalMargin)
            make.top.equalTo(self.toTextField.snp.bottom).offset(Dimension.shared.smallHorizontalMargin)
        }
    }
    
    private func setupViewToLabel() {
        self.view.addSubview(self.toLabel)
        
        self.toLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.toTextField)
            make.bottom.equalTo(self.toTextField.snp.top).offset(-Dimension.shared.mediumVerticalMargin)
        }
    }
    
    //MARK: - BETTER SEGMENT
    private func setupViewCustomSegment() {
        self.view.addSubview(self.betterSegment)
        
        self.betterSegment.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.widthCustomSegment)
            make.height.equalTo(Dimension.shared.heightCustomSegment)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.fromTextField.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewCollectionView() {
        self.view.addSubview(self.chartCollectionView)
        
        if #available(iOS 11, *) {
            self.chartCollectionView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaInsets)
                make.top.equalTo(self.betterSegment.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.chartCollectionView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                make.top.equalTo(self.betterSegment.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewNoneDataLabel() {
        self.view.addSubview(self.noneDataMessage)
        
        self.noneDataMessage.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension StatisticsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticalCell.identifier, for: indexPath) as? StatisticalCell else {
                return UICollectionViewCell()
            }
            
            cell.BPOFromToDate = self.BPOFromToDate
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PIECell.identifier, for: indexPath) as? PIECell else {
                return UICollectionViewCell()
            }
            
            cell.BPOFromToDate = self.BPOFromToDate
            
            return cell
        }
    }
    
}

//MARK: - UICollectionViewDelegate
extension StatisticsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}













