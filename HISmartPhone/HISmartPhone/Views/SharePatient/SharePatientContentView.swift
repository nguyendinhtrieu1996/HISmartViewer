//
//  SharePatientContentView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/25/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

protocol SharePatientContentDelegate: class {
    func showNoteAlert()
    func showUnSharedAlert(sharedPatient: SharedPatient?)
    func didSelectPatient(_ patientShare: Patient)
}

class SharePatientContentView: BaseUIView {
    
    // MARK: Define variables
    weak var delegate: SharePatientContentDelegate?
    
    var patients: [SharePatientByDoctor]? {
        didSet {
            self.basePatients = self.patients
        }
    }
    
    var sharedPatients: [SharedPatient]? {
        didSet {
            self.baseSharedPatients = self.sharedPatients
        }
    }
    
    fileprivate var basePatients: [SharePatientByDoctor]? {
        didSet {
            self.listPatientTableView.reloadData()
        }
    }
    
    fileprivate var baseSharedPatients: [SharedPatient]? {
        didSet {
            self.listPatientTableView.reloadData()
        }
    }
    
    fileprivate var shareType: ShareType = .Shared
    
    private let containtViewSearchBar: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.defaultBGColor
        return view
    }()
    
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.placeholder = "Tìm kiếm tin nhắn"
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()
    
    fileprivate lazy var listPatientTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Theme.shared.pickerBackgroundColor
        tableView.register(SharePatientCell.self, forCellReuseIdentifier: "SharePatientCell")
        tableView.register(BeSharePatientCell.self, forCellReuseIdentifier: "BeSharePatientCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return tableView
    }()
    
    init(shareType: ShareType) {
        super.init(frame: CGRect.zero)
        self.shareType = shareType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout View
    override func setupView() {
        self.setupViewContaintSearchView()
        self.setupViewSearchBar()
        self.setupViewListPatientTableView()
    }
    
    private func setupViewContaintSearchView() {
        self.addSubview(self.containtViewSearchBar)
        
        self.containtViewSearchBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightContainsViewSearchBar)
            make.centerX.top.equalToSuperview()
        }
    }
    
    private func setupViewSearchBar() {
        self.containtViewSearchBar.addSubview(self.searchBar)
        
        self.searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightSearchBar)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
        }
    }
    
    private func setupViewListPatientTableView() {
        self.addSubview(self.listPatientTableView)
        
        self.listPatientTableView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.containtViewSearchBar.snp.bottom)
                .offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    // MARK: Fetch data
    fileprivate func searchIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String) {
        switch self.shareType {
        case .Shared:
            if self.searchIsEmpty() {
                self.baseSharedPatients = self.sharedPatients
                return
            }
            
            guard let sharedPatients = self.sharedPatients else { return }
            self.baseSharedPatients = sharedPatients.filter { $0.name.lowercased().contains(searchText.lowercased())}
        case .BeShared:
            if self.searchIsEmpty() {
                self.basePatients = self.patients
                return
            }
            
            guard let patients = self.basePatients else { return }
            self.basePatients = patients.filter { $0.patientName.lowercased().contains(searchText.lowercased())}
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SharePatientContentView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.shareType {
        case .Shared:
            guard let patients = self.baseSharedPatients else {
                return 0
            }
            return patients.count
        case .BeShared:
            guard let patients = self.basePatients else {
                return 0
            }
            return patients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.shareType {
        case .Shared:
            guard let patients = self.baseSharedPatients else {
                return UITableViewCell()
            }
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "SharePatientCell",
                for: indexPath) as? SharePatientCell else {
                    return UITableViewCell()
            }
            
            cell.setValue(sharedPatient: patients[indexPath.row])
            cell.delegate = self
            return cell
        case .BeShared:
            guard let patients = self.basePatients else {
                return UITableViewCell()
            }
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "BeSharePatientCell",
                for: indexPath) as? BeSharePatientCell else {
                    return UITableViewCell()
            }
            
            cell.setValue(patientShared: patients[indexPath.row])
            cell.delegate = self
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Danh sach duoc chia se
        print("selected index = \(indexPath.item) ")
        
        if self.shareType == .Shared {
            guard let patient = self.basePatients?[indexPath.item].patientInfo else { return }
            self.delegate?.didSelectPatient(patient)
        } else {
            guard let patient = self.patients?[indexPath.item].patientInfo else { return }
            self.delegate?.didSelectPatient(patient)
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension SharePatientContentView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
    }
}

// MARK: -
extension SharePatientContentView: SharePatientDelegate {
    //Danh sach chia se
    func didSelectedSuperView(patientInfo: Patient) {
        print("select =================")
        self.delegate?.didSelectPatient(patientInfo)
    }
    
    func showNoteAlert() {
        self.delegate?.showNoteAlert()
    }
    
    func showUnSharedAlert(sharedPatient: SharedPatient?) {
        self.delegate?.showUnSharedAlert(sharedPatient: sharedPatient)
    }
}








