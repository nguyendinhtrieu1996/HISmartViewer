//
//  AccountController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class AccountController: BaseViewController {
    
    //MARK: Variable
    fileprivate let cellNameAccountId = "cellNameAccountId"
    fileprivate let cellInfoAccountId = "cellInfoAccountId"
    fileprivate var patient = Patient()
    fileprivate var doctor = User()
    
    //MARK: UIControl
    private let typeAccountLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    fileprivate lazy var infoTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CellNameAccount.self, forCellReuseIdentifier: self.cellNameAccountId)
        tableView.register(CellInfoAccount.self, forCellReuseIdentifier: self.cellInfoAccountId)
        
        return tableView
    }()
    
    private let floatButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "Edit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    //MARK: Initialize
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.tintColor = Theme.shared.defaultBGColor
        self.navigationController?.navigationBar.barTintColor = Theme.shared.primaryColor
    }
    
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewTypeAccountLabel()
        self.setupViewInfoTableView()
        self.setupViewFloatButton()
        self.setTitleAccountLabel()
        self.fetchData()
    }
    
    //MARK: Handle Action
    @objc func handleBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleEditButton() {
        if Authentication.share.typeUser == .doctor {
            let editAccDoctorVC = EditAccountDoctorController()
            editAccDoctorVC.delegate = self
            editAccDoctorVC.doctor = self.doctor.copy() as? User ?? User()
            self.navigationController?.pushViewController(editAccDoctorVC, animated: true)
        } else {
            let editAccountVC = EditAccountPatientController()
            editAccountVC.patient = self.patient.copy() as? Patient ?? Patient()
            editAccountVC.delegate = self
            self.navigationController?.pushViewController(editAccountVC, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait {
            self.infoTableView.isScrollEnabled = false
        } else {
            self.infoTableView.isScrollEnabled = true
        }
    }
    
    //MARK: Feature
    private func setTitleAccountLabel() {
        if Authentication.share.typeUser == .doctor {
            self.typeAccountLabel.text = "Tài khoản bác sĩ"
        } else {
            self.typeAccountLabel.text = "Tài khoản bệnh nhân"
        }
    }
    
    func fetchData() {
        if Authentication.share.typeUser == .patient {
            AccountFacade.fetchPatient(Authentication.share.currentUserId, completionHandler: { (patient) in
                self.patient = patient
                self.infoTableView.reloadData()
            })
        } else {
            self.doctor = Authentication.share.currentUser ?? User()
        }
    }
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"), target: self, selector: #selector(handleBackButton), title: "Thông tin tài khoản")
    }
    
    private func setupViewTypeAccountLabel() {
        self.view.addSubview(self.typeAccountLabel)
        
        self.typeAccountLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
            make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewInfoTableView() {
        self.view.addSubview(self.infoTableView)
        
        self.infoTableView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.typeAccountLabel.snp.bottom)
                .offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    private func setupViewFloatButton() {
        self.view.addSubview(self.floatButton)
        
        self.floatButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Dimension.shared.widthFloatButton)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
        
        self.floatButton.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension AccountController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellNameAccountId, for: indexPath) as? CellNameAccount else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = Theme.shared.darkBGColor
            cell.user = Authentication.share.currentUser
            cell.mainDoctor = self.patient.mainDoctor
            cell.followDoctor = self.patient.doctorsFollow ?? [User]()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellInfoAccountId, for: indexPath) as? CellInfoAccount else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = Theme.shared.darkBGColor
            
            if Authentication.share.typeUser == .doctor {
                cell.user = Authentication.share.currentUser
            } else {
                cell.patient = self.patient
            }
            
            return cell
        }
    }
    
}

//MARK: - EditAccountPatientControllerDelegate
extension AccountController: EditAccountPatientControllerDelegate {
    
    func doneSaveData(_ patient: Patient) {
        self.patient = patient.copy() as? Patient ?? Patient()
        self.infoTableView.reloadData()
    }
    
}

//MARK: - EditAccountDoctorControllerDelegate
extension AccountController: EditAccountDoctorControllerDelegate {
    
    func doneUpdateInfo(_ doctor: User) {
        self.doctor = doctor.copy() as? User ?? User()
        self.infoTableView.reloadData()
    }
    
}





