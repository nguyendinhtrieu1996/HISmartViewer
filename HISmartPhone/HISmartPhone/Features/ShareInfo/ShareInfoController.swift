//
//  ShareInfoController.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/14/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

//
class ShareInfoController: BaseViewController {
    
    // MARK: Define variables
    var patientID: String? {
        willSet {
            guard let id = newValue else {
                return
            }
            
            self.shareInfoFacade.fetchShareDoctors(_with: id) { (doctors) in
                self.dotors = doctors
                self.autoCompleteTableView.reloadData()
            }
        }
    }
    
    fileprivate var dotors: [User] = []
    fileprivate let shareInfoFacade: ShareInfoFacade = ShareInfoFacade()
    
    // MARK: Define control
    private let shareToDoctorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Chia sẻ đến Bác sĩ"
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "Lời nhắn kèm"
        return label
    }()
    
    private let shareToDoctorTextField: CustomTextField = CustomTextField(placeholder: "Nhập tên bác sĩ")
    private let noteTextField: CustomTextField = CustomTextField(placeholder: "Nhập nội dung lời nhắn")
    
    fileprivate lazy var autoCompleteTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.register(AutoCompleteTableViewCell.self, forCellReuseIdentifier: "AutoCompleteTableViewCell")
        tableView.backgroundColor = Theme.shared.darkBGColor
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    // MARK: Setup UI
    override func setupView() {
        self.setTitle()
        self.setupViewNavigationBar()
        self.setupShareToDoctorLabel()
        self.setupShareToDoctorTextField()
        //self.setupNoteLabel()
        //self.setupNoteTextField()
        //self.present(ShareInfoPatientAlert(), animated: true, completion: nil)
    }
    
    //BACK ITEM
    private func setupViewNavigationBar() {
        self.navigationItem.addLeftBarItem(
            with: UIImage(named: "back_white"),
            target: self,
            selector: #selector(ShareInfoController.handleBackButton),
            title: nil
        )
        self.navigationItem.addRightBarItems(
            with: "GỬI",
            target: self,
            selector: #selector(ShareInfoController.handleSendButton)
        )
    }
    
    private func setTitle() {
        let nameLabel = UILabel()
        nameLabel.text = "Share Hồ sơ thông tin"
        nameLabel.textColor = Theme.shared.defaultTextColor
        nameLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize,
                                           weight: UIFont.Weight.medium)
        
        self.navigationItem.titleView = nameLabel
    }
    
    private func setupShareToDoctorLabel() {
        self.view.addSubview(self.shareToDoctorLabel)
        
        if #available(iOS 11, *) {
            self.shareToDoctorLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.view.safeAreaInsets)
                    .offset(Dimension.shared.largeVerticalMargin_42)
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
            }
        } else {
            self.shareToDoctorLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.largeVerticalMargin_42)
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
            }
        }
  
    }
    
    private func setupShareToDoctorTextField() {
        self.view.addSubview(self.shareToDoctorTextField)
        self.shareToDoctorTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.shareToDoctorLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.right.equalTo(self.shareToDoctorLabel)
        }
        self.shareToDoctorTextField.delegate = self
    }
    
    private func setupNoteLabel() {
        self.view.addSubview(self.noteLabel)
        self.noteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.shareToDoctorTextField.snp.bottom).offset(Dimension.shared.largeVerticalMargin_42)
            make.left.right.equalTo(self.shareToDoctorTextField)
        }
    }
    
    private func setupNoteTextField() {
        self.view.addSubview(self.noteTextField)
        self.noteTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self.noteLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.right.equalTo(self.noteLabel)
        }
    }
    
    fileprivate func setupAutoCompleteTableView(customTextField: CustomTextField) {
        self.view.addSubview(self.autoCompleteTableView)
        
        self.autoCompleteTableView.snp.makeConstraints { (make) in
            make.top.equalTo(customTextField.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(customTextField)
            
            if self.dotors.count < 5 {
                make.height.equalTo(60 * self.dotors.count)
            } else {
                make.height.equalTo(4 * 50)
            }
        }
    }
    
    fileprivate func reMakeAutoCompleteTableView(customTextField: CustomTextField) {
        self.autoCompleteTableView.snp.remakeConstraints { (make) in
            make.top.equalTo(customTextField.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalTo(customTextField)
            
            if self.dotors.count < 5 {
                make.height.equalTo(60 * self.dotors.count)
            } else {
                make.height.equalTo(4 * 50)
            }
        }
    }
    
    // MARK: Handle Action
    @objc private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSendButton() {
        self.shareInfoFacade.SharePatientToDoctor { (result) in
            if result {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "Lỗi", message: "Vui lòng kiểm tra lại", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "Đồng ý", style: .default, handler: nil)
                alert.addAction(okBtn)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: Extension
extension ShareInfoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dotors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "AutoCompleteTableViewCell",
            for: indexPath
            ) as? AutoCompleteTableViewCell else {
                return UITableViewCell()
        }
        cell.setValue(doctorName: self.dotors[indexPath.row].fullName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.shareToDoctorTextField.setValue(text: self.dotors[indexPath.row].fullName)
        self.shareInfoFacade.setSelectedDoctor(doctor: self.dotors[indexPath.row])
    }
}

extension ShareInfoController: CustomTextFieldDelegate {
    func editingBegin(customTextField: CustomTextField) {
        self.dotors = shareInfoFacade.doctors
        self.autoCompleteTableView.reloadData()
        self.setupAutoCompleteTableView(customTextField: customTextField)
    }
    
    func editingDidEnd(customTextField: CustomTextField) {
        self.autoCompleteTableView.removeConstraints(self.autoCompleteTableView.constraints)
        self.autoCompleteTableView.removeFromSuperview()
    }
    
    func editingChanged(customTextField: CustomTextField, text: String?) {
        guard let text = text else {
            return
        }
        
        if text == "" {
            self.dotors = shareInfoFacade.doctors
        } else {
            self.dotors = shareInfoFacade.doctors.filter { $0.fullName.lowercased().contains(text.lowercased())}
        }
        
        self.autoCompleteTableView.reloadData()
        self.reMakeAutoCompleteTableView(customTextField: customTextField)
    }
}

