//
//  EditPatientBloodPressureController.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class EditPatientBloodPressureController: BaseViewController {
    
    // MARK: Define control
    private let editView = EditPatientBloodPressureWarningView()
    
    // MARK: Setup layout
    override func setupView() {
        self.setTitle()
        self.setupViewNavigationBar()
        self.setupEditView()
    }
    
    private func setupEditView() {
        self.view.addSubview(self.editView)
        self.editView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalToSuperview()
        }
        self.editView.patient = HISMartManager.share.currentPatient
    }
    
    //BACK ITEM
    private func setupViewNavigationBar() {
        self.navigationItem.addLeftBarItem(
            with: UIImage(named: "back_white"),
            target: self,
            selector: #selector(EditPatientBloodPressureController.handleBackButton),
            title: nil
        )
        self.navigationItem.addRightBarItems(
            with: "LƯU",
            target: self,
            selector: #selector(EditPatientBloodPressureController.handleSaveButton)
        )
    }
    
    private func setTitle() {
        let nameLabel = UILabel()
        nameLabel.text = "Chỉnh sửa thông số"
        nameLabel.textColor = Theme.shared.defaultTextColor
        nameLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize,
                                           weight: UIFont.Weight.medium)
        
        self.navigationItem.titleView = nameLabel
    }
    
    //MARK: Handle Action
    @objc private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSaveButton() {
        
        if !self.editView.systolic.CheckValue() || !self.editView.diastolic.CheckValue() {
            let alert = UIAlertController(title: "Thông báo", message: "Vui long kiểm tra lại thông tin", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Đồng ý", style: .default, handler: nil)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        PatientInfomationFacade.updatePatientBloodPressureWarning(patientID: HISMartManager.share.currentPatient.PID_ID, systolic: self.editView.systolic, diastolic: self.editView.diastolic) { (bool) in
            if bool {
                HISMartManager.share.currentPatient.setSystolic(bloodPressure: self.editView.systolic)
                HISMartManager.share.currentPatient.setDiastolic(bloodPressure: self.editView.diastolic)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
