//
//  UnSharedAlertView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

protocol UnSharedAlertViewDelegate: class {
    func confirmUnshare(patientID: String, doctorsID: [String])
    func cancel()
}

// This class display one or list doctor will be unshared
class UnSharedAlertView: BaseUIView {
    
    // MARK: Define variable
    var sharedPatient: SharedPatient? {
        didSet {
            guard let value = self.sharedPatient else { return }
            self.isShowListDoctor(isShow: value.doctors.count > 1)
            if value.doctors.count > 1 {
                self.titleLabel.text = "Bạn chắc chắn muốn Unshare Hồ sơ thông tin bệnh nhân này với các bác sĩ không?"
                self.doctorNameTableView.reloadData()
            } else {
                guard let doctor = value.doctors.first else { return }
                self.titleLabel.text = "Bạn chắc chắn muốn Unshare Hồ sơ thông tin bệnh nhân này với bs. \(doctor.name) không ?"
            }
        }
    }
    weak var delegate: UnSharedAlertViewDelegate?
    
    // MARK: Define control
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var doctorNameTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CheckBoxDoctorNameCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.shared.primaryColor
        button.setTitle("XÁC NHẬN", for: .normal)
        button.setTitleColor(Theme.shared.defaultTextColor, for: .normal)
        button.layer.cornerRadius = Dimension.shared.heightButtonAlert / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.shared.accentColor
        button.setTitle("HUỶ", for: .normal)
        button.setTitleColor(Theme.shared.defaultTextColor, for: .normal)
        button.layer.cornerRadius = Dimension.shared.heightButtonAlert / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: Control
    func isShowListDoctor(isShow: Bool) {
        self.doctorNameTableView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            if isShow {
                make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
                make.height.equalTo(2*32)
            } else {
                make.top.equalTo(self.titleLabel.snp.bottom)
                make.height.equalTo(0)
            }
        }
    }
    
    // MARK: Layout UI
    override func setupView() {
        self.setupMainView()
        self.layoutTitleLabel()
        self.layoutDoctorNameTable()
        self.layoutConfirmButton()
        self.layoutCancelButton()
    }
    
    private func setupMainView(){
        self.backgroundColor = Theme.shared.defaultBGColor
        self.layer.cornerRadius = Dimension.shared.normalCornerRadius
        self.clipsToBounds = true
    }
    
    private func layoutTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
        }
    }
    
    private func layoutDoctorNameTable() {
        self.addSubview(self.doctorNameTableView)
        self.doctorNameTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            make.height.equalTo(2*32)
        }
    }
    
    private func layoutConfirmButton() {
        self.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.doctorNameTableView.snp.bottom).offset(Dimension.shared.largeVerticalMargin_32)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_32)
            make.height.equalTo(Dimension.shared.heightButtonAlert)
        }
        self.confirmButton.addTarget(self, action: #selector(UnSharedAlertView.handleConfirmButton), for: .touchUpInside)
    }
    
    private func layoutCancelButton() {
        self.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.confirmButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.right.equalTo(self.confirmButton)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
            make.height.equalTo(Dimension.shared.heightButtonAlert)
        }
        self.cancelButton.addTarget(self, action: #selector(UnSharedAlertView.handeleCancelButton), for: .touchUpInside)
    }
    
    // MARK: Handle action
    @objc private func handleConfirmButton() {
        guard let sharedPatient = self.sharedPatient else {
            return
        }
        
        let doctorsID = sharedPatient.doctors.filter { $0.selected }.map{ $0.id }
        self.delegate?.confirmUnshare(patientID: sharedPatient.id, doctorsID: doctorsID)
    }
    
    @objc private func handeleCancelButton() {
        self.delegate?.cancel()
    }
}

// Extension
extension UnSharedAlertView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let doctor = self.sharedPatient?.doctors else { return 0 }
        return doctor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let doctor = self.sharedPatient?.doctors[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
            ) as? CheckBoxDoctorNameCell else { return UITableViewCell() }
        cell.setValue(doctorName: doctor.name, isSelected: doctor.selected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let doctor = self.sharedPatient?.doctors[indexPath.row] else { return }
        doctor.selected = !doctor.selected
        tableView.reloadData()
    }
}
