//
//  ListPatientController.swift
//  HISmartPhone
//
//  Created by MACOS on 12/21/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ListPatientController: BaseViewController {
    
    //MARK: Variable
    fileprivate let cellId = "cellId"
    fileprivate var listPatient = [Patient]()
    fileprivate var filterListPatient = [Patient]()
    fileprivate var isSorting = false
    
    //MARK: UIControl
    fileprivate lazy var alertSigout: AlertAnnoucementSignoutController = {
        let alert = AlertAnnoucementSignoutController()
        
        alert.setMessage("Bạn chắc chắn \n muốn đăng xuất khỏi hệ thống")
        alert.alertDelegate = self
        
        return alert
    }()
    
    fileprivate lazy var sideMenuVC: SideMenuController = {
        let menu = SideMenuController()
        menu.delegate = self
        return menu
    }()
    
    fileprivate lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.delegate = self
        searchBar.placeholder = "Tìm kiếm bệnh nhân"
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()
    
    private let searchBarView: UIView = {
        let viewConfig = UIView()
        viewConfig.backgroundColor = UIColor.clear
        return viewConfig
    }()
    
    private let contentSearchView: UIView = {
        let viewConfig = UIView()
        
        viewConfig.backgroundColor = Theme.shared.lightNavigationBarColor
        viewConfig.makeShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 1.0, radius: 7.0)
        
        return viewConfig
    }()
    
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        
        label.text = "STT"
        label.textAlignment = .center
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Mã BN liên kết"
        label.textAlignment = .left
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Số điện thoại"
        label.textAlignment = .right
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    fileprivate lazy var tableViewListPatient: UITableView = {
        let tableViewConfig = UITableView()
        
        tableViewConfig.delegate = self
        tableViewConfig.dataSource = self
        tableViewConfig.separatorColor = UIColor.clear
        tableViewConfig.register(ListPatientCell.self, forCellReuseIdentifier: self.cellId)
        tableViewConfig.backgroundColor = Theme.shared.defaultBGColor
        tableViewConfig.estimatedRowHeight = 100
        tableViewConfig.rowHeight = UITableViewAutomaticDimension
        
        return tableViewConfig
    }()
    
    //MARK: Initialize
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HISMartManager.share.updateIsListPatientVC(true)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.tintColor = Theme.shared.darkBlueTextColor
        self.setupViewNavigationBar()
    }
    
    override func setupView() {
        self.addLeftBarItem()
        self.setupViewContainSearchView()
        self.setupViewSearchBar()
        self.setupViewNavigationBar()
        self.setupViewOrderNumberLabel()
        self.setupViewCodeLabel()
        self.setupViewPhoneNumberLabel()
        self.setupViewListPatientTableView()
        self.fetchData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addLeftBarItem), name: NSNotification.Name.init(Notification.Name.obseverMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addRightBarItem), name: NSNotification.Name.init(Notification.Name.updateNotification), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        HISMartManager.share.updateIsListPatientVC(false)
    }
    
    //MARK: Action UIControl
    @objc func handleWarningButton() {
        self.navigationController?.pushViewController(WarningController(), animated: true)
    }
    
    @objc func handleOptionMenu() {
        self.present(self.sideMenuVC, animated: true) {
            //TO DO
        }
    }
    
    @objc func addRightBarItem() {
        //NOTICE
        let warningButton = SSBadgeButton()
        warningButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        warningButton.setImage(UIImage(named: "warning_blue"), for: .normal)
        warningButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 4)
        warningButton.badge = "\(BloodPressureNotifiHelper.shared.newBPNotifications.count)"
        warningButton.addTarget(self, action: #selector(handleWarningButton), for: .touchUpInside)
        let warningItem = UIBarButtonItem(customView: warningButton)
        self.navigationItem.rightBarButtonItem = warningItem
    }
    
    //MARK: Feature
    private func fetchData() {
        ListPatientFacade.loadAllPatient { (listPatient) in
            self.listPatient = listPatient
            self.filterListPatient = self.listPatient
            self.tableViewListPatient.reloadData()
        }
    }
    
    fileprivate func searchIsEmpty() -> Bool {
        return self.searchBar.text?.isEmpty ?? true
    }
    
    fileprivate func filterContentForSearchText(_ searchText: String, scrop: String = "All") {
        if self.searchIsEmpty() {
            self.filterListPatient = self.listPatient
            return
        }
        
        self.filterListPatient = self.listPatient.filter {
            $0.patient_Name.lowercased().contains(searchText.lowercased()) || $0.patient_ID.lowercased().contains(searchText.lowercased())
        }
    }
    
    fileprivate func isFiltering() -> Bool {
        return !self.searchIsEmpty()
    }
    
    //MARK: SetupView
    @objc private func addLeftBarItem() {
        let number = HISMartManager.share.numberNewMessages
    
        //OPTION
        let optionButton = SSBadgeButton()
        optionButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        optionButton.setImage(UIImage(named: "main_menu_blue"), for: .normal)
        optionButton.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 1)
        optionButton.badge = number == 0 ? nil : number.description
        optionButton.addTarget(self, action: #selector(handleOptionMenu), for: .touchUpInside)
        let optionItem = UIBarButtonItem(customView: optionButton)
        
        self.navigationItem.leftBarButtonItems = [optionItem]
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func setupViewNavigationBar() {
        //TITLE LABEL
        let titleLabel = UILabel()
        titleLabel.text = "Danh sách bệnh nhân"
        titleLabel.textAlignment = .center
        titleLabel.textColor = Theme.shared.darkBlueTextColor
        titleLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        titleLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        self.navigationItem.titleView = titleLabel
        
        //NOTICE
        let warningButton = SSBadgeButton()
        warningButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        warningButton.setImage(UIImage(named: "warning_blue"), for: .normal)
        warningButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 4)
        warningButton.badge = "\(BloodPressureNotifiHelper.shared.newBPNotifications.count)"
        warningButton.addTarget(self, action: #selector(handleWarningButton), for: .touchUpInside)
        let warningItem = UIBarButtonItem(customView: warningButton)
        self.navigationItem.rightBarButtonItem = warningItem
        
        
        
        //CUSTOM NAVIBAR
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = Theme.shared.lightNavigationBarColor
    }
    
    private func setupViewContainSearchView() {
        self.view.addSubview(self.contentSearchView)
        
        if #available(iOS 11, *) {
            self.contentSearchView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightContainsViewSearchBar)
                make.top.equalTo(self.view.safeAreaInsets)
            }
        } else {
            self.contentSearchView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightContainsViewSearchBar)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func setupViewSearchBar() {
        self.contentSearchView.addSubview(self.searchBar)
        
        self.searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
            make.centerY.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightSearchBar)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupViewOrderNumberLabel() {
        self.view.addSubview(self.orderNumberLabel)
        
        if #available(iOS 11, *) {
            self.orderNumberLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentSearchView.snp.bottom).offset(11 * Dimension.shared.heightScale)
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.mediumHorizontalMargin)
            }
        } else {
            self.orderNumberLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.contentSearchView.snp.bottom).offset(11 * Dimension.shared.heightScale)
                make.left.equalToSuperview().offset(Dimension.shared.mediumHorizontalMargin)
            }
        }
        
    }
    
    private func setupViewCodeLabel() {
        self.view.addSubview(self.codeLabel)
        
        self.codeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.orderNumberLabel)
            make.left.equalTo(self.orderNumberLabel.snp.right).offset(37 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewPhoneNumberLabel() {
        self.view.addSubview(self.phoneLabel)
        
        if #available(iOS 11, *) {
            self.phoneLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.orderNumberLabel)
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.mediumVerticalMargin)
            }
        } else {
            self.phoneLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.orderNumberLabel)
                make.right.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
            }
        }
        
    }
    
    private func setupViewListPatientTableView() {
        self.view.addSubview(self.tableViewListPatient)
        
        if #available(iOS 11, *) {
            self.tableViewListPatient.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.orderNumberLabel.snp.bottom)
                    .offset(Dimension.shared.mediumVerticalMargin)
                
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        } else {
            self.tableViewListPatient.snp.makeConstraints { (make) in
                make.width.bottom.centerX.equalToSuperview()
                make.top.equalTo(self.orderNumberLabel.snp.bottom)
                    .offset(Dimension.shared.mediumVerticalMargin)
            }
        }
    }
    
}

//MARK: - UISearchResultsUpdating
extension ListPatientController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListPatientController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterListPatient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? ListPatientCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.index = (indexPath.item + 1)
        cell.patient = self.filterListPatient[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HISMartManager.share.setCurrentPatient(self.filterListPatient[indexPath.item])
        BPOChartManager.shared.BPOResults.removeAll()
        BPOHelper.shared.BPOResults.removeAll()
        
        self.present(TabBarController(), animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
}

//MARK: - SideMenuControllerDelegate
extension ListPatientController: SideMenuControllerDelegate {
    
    func presentVC(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popToListPatient() {
        //
    }
    
    func didSelectLogout() {
        self.present(self.alertSigout, animated: true, completion: nil)
    }
    
}

//MARK: - AlertAnnoucementSignoutControllerDelegate
extension ListPatientController: AlertAnnoucementSignoutControllerDelegate {
    
    func didSelectSignOut() {
        Authentication.share.signOut()
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = UINavigationController(rootViewController: LoginController())
    }
    
}

//MARK: - UISearchBarDelegate
extension ListPatientController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
        self.tableViewListPatient.reloadData()
    }
}


