//
//  StatisticalAnalysisController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/25/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class StatisticalAnalysisController: BaseViewController {
    
    //MARK: Variable
    fileprivate var isSelectFromDate = true
    fileprivate let cellAverageBloodPressueId = "cellAverageBloodPressueId"
    fileprivate let cellSurpassTheThresholdId = "cellSurpassTheThresholdId"
    fileprivate var fromDate: Date?
    fileprivate var toDate: Date?
    
    //MARK: UIControl
    fileprivate let datePicker: UIDatePicker = {
        let datePickerConfig = UIDatePicker()
        
        datePickerConfig.datePickerMode = .date
        datePickerConfig.locale = Locale(identifier: "vi-VN")
        datePickerConfig.maximumDate = Date()
        
        return datePickerConfig
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Kết quả huyết áp"
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        
        return label
    }()
    
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
    
    fileprivate lazy var resultTableView: UITableView = {
        let tabelView = UITableView()
        
        tabelView.isHidden = true
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.separatorColor = UIColor.clear
        tabelView.backgroundColor = UIColor.clear
        tabelView.estimatedRowHeight = 100
        tabelView.isScrollEnabled = false
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.register(AverageBloodPressureCel.self, forCellReuseIdentifier: self.cellAverageBloodPressueId)
        tabelView.register(SurpassTheThresholdCell.self, forCellReuseIdentifier: self.cellSurpassTheThresholdId)
        
        return tabelView
    }()
    
    //MARK: Initialize function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.orientation.isLandscape {
            self.resultTableView.isScrollEnabled = true
        } else {
            self.resultTableView.isScrollEnabled = false
        }
    }
    
    override func setupView() {
        
        self.setupViewNavigationBar()
        self.setupViewTitleLabel()
        
        self.setupViewFromTextfiled()
        self.setupViewFromDropItemImage()
        self.setupViewFromLineDivider()
        self.setupViewFromLabel()
        
        self.setupViewToTextfiled()
        self.setupViewToDropItemImage()
        self.setupViewToLineDivider()
        self.setupViewToLabel()
        self.setupViewResultTableView()
        
        self.fromTextField.becomeFirstResponder()
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(superViewTapped))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Feature
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.current.orientation.isLandscape {
            self.resultTableView.isScrollEnabled = true
        } else {
            self.resultTableView.isScrollEnabled = false
        }
    }
    
    private func fetchData() {
        guard let fromDate = self.fromDate else { return }
        guard let toDate = self.toDate else { return }
        
        StatisticalAnalysisFacade.getStaticsticalFromToDate(fromDate: fromDate, toDate: toDate) { (BPOResults) in
            self.resultTableView.isHidden = false
            self.resultTableView.reloadData()
        }
    }
    
    //MARK: Action UIControl
    @objc func superViewTapped() {
        self.view.endEditing(true)
    }
    
    @objc func backButtonPressed() {
        BPOHelper.shared.BPOResults.removeAll()
        self.navigationController?.popViewController(animated: true)
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
        self.fetchData()
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
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //TITLE
        let titleLabel = UILabel()
        titleLabel.text = "Phân tích thống kê"
        titleLabel.textColor = Theme.shared.defaultTextColor
        titleLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        titleLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        self.navigationItem.titleView = titleLabel
        
        //BACK ITEM
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"), target: self, selector: #selector(backButtonPressed), title: nil)
    }
    
    private func setupViewTitleLabel() {
        self.view.addSubview(self.titleLabel)
        
        if #available(iOS 11, *) {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.view.safeAreaInsets)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    //FROM
    private func setupViewFromTextfiled() {
        self.view.addSubview(self.fromTextField)
        
        if #available(iOS 11, *) {
            self.fromTextField.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(Dimension.shared.widthFROMANDTOTextField)
                make.height.equalTo(Dimension.shared.defaultHeightTextField)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(3 * Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.fromTextField.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(Dimension.shared.widthFROMANDTOTextField)
                make.height.equalTo(Dimension.shared.defaultHeightTextField)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(3 * Dimension.shared.normalVerticalMargin)
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
    
    //TO
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
    
    private func setupViewResultTableView() {
        self.view.addSubview(self.resultTableView)
        
        self.resultTableView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.fromLineDivider.snp.bottom).offset(Dimension.shared.largeHorizontalMargin)
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension StatisticalAnalysisController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellAverageBloodPressueId, for: indexPath) as? AverageBloodPressureCel else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = Theme.shared.darkBGColor
            cell.setData()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellSurpassTheThresholdId, for: indexPath) as? SurpassTheThresholdCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = Theme.shared.darkBGColor
            cell.setData()
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}









