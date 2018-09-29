//
//  PatientInformationController.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class display information of patient
class PatientInformationController: BaseViewController {
    
    // MARK: Define controls
    private let scrollView: BaseScrollView = BaseScrollView(frame: .zero)
    private let headerPatientInfoView: HeaderPatientInfoView = HeaderPatientInfoView()
    private let infoPatientView: InfoPatientView = InfoPatientView()
    private let patientMedicalInfoView: PatientMedicalInfoView = PatientMedicalInfoView()
    private let patientBloodPressureWarningView: PatientBloodPressureWarningView = PatientBloodPressureWarningView()
    
    // MARK: Setup layout
    override func setupView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        self.setTitle()
        self.setupViewNavigationBar()
        self.setupHeaderPatientInfoView()
        self.setupInfoPatientView()
        self.setupPatientMedicalInfoView()
        self.setupPatientBloodPressureWarningView()
        
        self.headerPatientInfoView.mainDoctor = HISMartManager.share.currentDoctor
        
        PatientInfomationFacade.getAddressForCurrentPatient {
            self.infoPatientView.address = HISMartManager.share.currentPatient.address?.getDescription()
            self.headerPatientInfoView.users = HISMartManager.share.currentPatient.doctorsFollow ?? [User]()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.patientBloodPressureWarningView.patient = HISMartManager.share.currentPatient
    }
    
    private func setupViewNavigationBar() {
        self.navigationItem.addLeftBarItem(
            with: UIImage(named: "back_white"),
            target: self,
            selector: #selector(PatientInformationController.handleBackButton),
            title: nil
        )
    }
    
    private func setTitle() {
        let nameLabel = UILabel()
        nameLabel.text = "Thông tin bệnh nhân"
        nameLabel.textColor = Theme.shared.defaultTextColor
        nameLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize,
                                           weight: UIFont.Weight.medium)
        
        self.navigationItem.titleView = nameLabel
    }
    
    private func setupHeaderPatientInfoView() {
        self.scrollView.view.addSubview(self.headerPatientInfoView)
        self.headerPatientInfoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            make.left.right.equalToSuperview()
            make.width.equalTo(self.view)
        }
    }
    
    private func setupInfoPatientView() {
        self.scrollView.view.addSubview(self.infoPatientView)
        self.infoPatientView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerPatientInfoView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.width.equalTo(self.headerPatientInfoView)
        }
    }
    
    private func setupPatientMedicalInfoView() {
        self.scrollView.view.addSubview(self.patientMedicalInfoView)
        self.patientMedicalInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoPatientView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.width.equalTo(self.infoPatientView)
        }
    }
    
    private func setupPatientBloodPressureWarningView() {
        self.scrollView.view.addSubview(self.patientBloodPressureWarningView)
        self.patientBloodPressureWarningView.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientMedicalInfoView.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
            make.width.equalTo(self.patientMedicalInfoView)
            make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
        }
        
        self.patientBloodPressureWarningView.delegate = self
    }
    
    // MARK: Action
    @objc private func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Extension
extension PatientInformationController: PatientBloodPressureWarningDelegate {
    func editingPatientBloodPressure() {
        let editPatientBloodPressureController = EditPatientBloodPressureController()
        self.navigationController?.pushViewController(editPatientBloodPressureController, animated: true)
    }
}
