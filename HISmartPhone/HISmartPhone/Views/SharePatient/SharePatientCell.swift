//
//  SharePatientCell.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 12/31/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

//
protocol SharePatientDelegate: class {
    func showNoteAlert()
    func showUnSharedAlert(sharedPatient: SharedPatient?)
    func didSelectedSuperView(patientInfo: Patient)
}

// This class display information of Patient
class SharePatientCell: BaseTableViewCell {
    
    // MARK: Define variable
    private var sharedPatient: SharedPatient?
    weak var delegate: SharePatientDelegate?
    fileprivate var doctors: [DoctorBeShared]? {
        didSet {
            guard let doctors = self.doctors else { return }
            self.layoutDoctorNameTableView(count: doctors.count)
            self.doctorNameTableView.reloadData()
        }
    }
    
    //MARK: Define control
    private let dateShareLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        label.textColor = Theme.shared.grayTextColor

        return label
    }()
    
    private let circleView: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = Theme.shared.heartRateChartColor
        viewConfig.layer.cornerRadius = Dimension.shared.widthStatusCircle / 2
        viewConfig.layer.masksToBounds = true
        return viewConfig
    }()
    
    private let patientNameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
     
        return label
    }()
    
    private lazy var doctorNameTableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(DoctorNameCell.self, forCellReuseIdentifier: "cellID")
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.shared.transparentColor
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private let noteButton: UIButton = {
        let button : UIButton = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "note"), for: .normal)
        return button
    }()
    
    private let unSharedButton: UIButton = {
        let button : UIButton = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "share_off"), for: .normal)
        return button
    }()
    
    // MARK: Control UI
    // TODO: add isShow into this function
    // This function to show or hide UnShare Button
    @objc private func showUnShare() {
//        self.unSharedButton.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.dateShareLabel)
//            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
//            make.width.height.equalTo(0)
//        }
//        self.noteButton.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.unSharedButton)
//            make.right.equalTo(self.unSharedButton.snp.left)
//        }
        self.delegate?.showUnSharedAlert(sharedPatient: self.sharedPatient)
    }
    
    //
    @objc private func showNote() {
        self.delegate?.showNoteAlert()
    }
    
    // MARK: Setup UI
    override func setupView() {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapSuperView))
        self.addGestureRecognizer(tapGesture)
        
        self.selectionStyle = .none
        self.backgroundColor = Theme.shared.transparentColor
//        self.layoutDateShareLabel()
        self.layoutCircleView()
        self.layoutUnSharedButton()
//        self.layoutNoteButton()
        self.layoutPatientNameLabel()
    }
    
    @objc func handleTapSuperView() {
        guard let patientInfo = self.sharedPatient?.patientInfo else {
            return
        }
        self.delegate?.didSelectedSuperView(patientInfo: patientInfo)
    }
    
    private func layoutDateShareLabel() {
        self.addSubview(self.dateShareLabel)
        self.dateShareLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func layoutCircleView() {
        self.addSubview(self.circleView)
        self.circleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.width.height.equalTo(15)
        }
    }
    
    private func layoutUnSharedButton() {
        self.addSubview(self.unSharedButton)
        self.unSharedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.circleView)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
        self.unSharedButton.addTarget(self, action: #selector(SharePatientCell.showUnShare), for: .touchUpInside)
    }
    
    private func layoutNoteButton() {
        self.addSubview(self.noteButton)
        self.noteButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.unSharedButton)
            make.right.equalTo(self.unSharedButton.snp.left).offset(-Dimension.shared.largeHorizontalMargin_32)
        }
        self.noteButton.addTarget(self, action: #selector(SharePatientCell.showNote), for: .touchUpInside)
    }
    
    private func layoutPatientNameLabel() {
        self.addSubview(self.patientNameLabel)
        self.patientNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_60)
        }
    }
    
    private func layoutDoctorNameTableView(count: Int) {
        self.addSubview(self.doctorNameTableView)
        self.doctorNameTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.patientNameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.left.equalTo(self.patientNameLabel)
            make.right.equalTo(self.unSharedButton.snp.left)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
            make.height.equalTo(20 * count)
        }
    }
    
    // MARK: SetData
    func setValue(sharedPatient: SharedPatient) {
        self.patientNameLabel.text = "\(sharedPatient.name) / \(sharedPatient.patientInfo.patient_ID)"
        self.doctors = sharedPatient.doctors
        self.sharedPatient = sharedPatient
    }
}

// MARK: Extension
extension SharePatientCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let doctors = self.doctors else { return 0 }
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let doctors = self.doctors else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cellID",
            for: indexPath
            ) as? DoctorNameCell else { return UITableViewCell() }
        cell.setValue(doctorName: doctors[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(cell.frame.size)
    }
}



