//
//  AlermController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/28/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class WarningController: BaseViewController {
    
    fileprivate let cellId = "cellId"
    fileprivate var bloodPressures = [BloodPressureNotification]()
    fileprivate var isUpdate = false
    
    //MARK: UIControl
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(WarningCell.self, forCellReuseIdentifier: self.cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.shared.defaultBGColor
        
        return tableView
    }()
    
    fileprivate let emptyLabel: UILabel = {
       let label = UILabel()
        
        label.isHidden = true
        label.text = "Không có thông báo huyết áp nào"
        label.textColor = Theme.shared.primaryColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    //MARK: Life circle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //CUSTOM NAVIBAR
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.barTintColor = Theme.shared.primaryColor
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewTableView()
        self.setupViewNavigationBar()
        self.setTitle()
        self.setupViewEmptyLabel()
        
        self.updateNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotifications), name: NSNotification.Name.init(Notification.Name.updateNotification), object: nil)
    }
    
    //MARK: Handle UIControl
    @objc func backButtonPressed() {
        BloodPressureNotifiHelper.shared.updateStatusNotification {
            //
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Feature
    @objc func updateNotifications() {
        self.bloodPressures = BloodPressureNotifiHelper.shared.bloodPressures
        self.tableView.reloadData()
        
        if self.bloodPressures.count == 0 {
            self.emptyLabel.isHidden = false
        } else {
            self.emptyLabel.isHidden = true
        }
        
        if !isUpdate {
            BloodPressureNotifiHelper.shared.updateStatusNotification {
                //
            }
            isUpdate = true
        }
        
    }
    
    //MARK: SetupView
    private func setupViewTableView() {
        self.view.addSubview(self.tableView)
        
        if #available(iOS 11, *) {
            self.tableView.snp.makeConstraints({ (make) in
                make.width.centerX.centerY.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            })
        } else {
            self.tableView.snp.makeConstraints { (make) in
                make.width.height.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    private func setupViewNavigationBar() {
        //BACK ITEM
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"), target: self, selector: #selector(backButtonPressed), title: nil)
    }
    
    private func setTitle() {
        let nameLabel = UILabel()
        nameLabel.text = "Báo động huyết áp"
        nameLabel.textColor = Theme.shared.defaultTextColor
        nameLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        self.navigationItem.titleView = nameLabel
    }
    
    private func setupViewEmptyLabel() {
        self.view.addSubview(self.emptyLabel)
        
        self.emptyLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension WarningController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bloodPressures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? WarningCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.bloodPressure = self.bloodPressures[indexPath.item]
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension WarningController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blooPressure = self.bloodPressures[indexPath.item]
        let fromToDateChartVC = ChartFromToDateController()
        fromToDateChartVC.fetchData(blooPressure.createDate, for: blooPressure.patientID, blooPressure.patientName)
        self.navigationController?.pushViewController(fromToDateChartVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Xoá") { (action, indexPath) in
            let key = self.bloodPressures[indexPath.item].key
            if key == "" { return }
            WarningFacade.deleteBloodPressureNotifi(with: key)
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (Authentication.share.typeUser == .patient) {
            return false
        } else {
            return true
        }
    }
    
}



