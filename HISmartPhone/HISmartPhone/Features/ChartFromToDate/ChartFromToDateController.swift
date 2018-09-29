//
//  ChartFromToDateController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class ChartFromToDateController: BaseViewController {
    
    //MARK: Variable
    fileprivate let cellChartId = "cellChartId"
    fileprivate let cellDetailInfoId = "cellDetailInfoId"
    fileprivate let cellNoteId = "cellNoteId"
    fileprivate var indexSelected: Int?
    fileprivate var BPOFromToDate = BPOFromToDateManager()
    
    //MARK: UIControl
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Đồ thị huyết áp"
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        label.textColor = Theme.shared.primaryColor
        
        return label
    }()
    
    private let noneDataMessage: UILabel = {
        let label = UILabel()
        
        label.text = "Không có kết quả huyết áp nào"
        label.textColor = Theme.shared.darkBlueTextColor
        label.textAlignment = .center
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    lazy var chartTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = Theme.shared.defaultBGColor
        tableView.register(ChartFromDateToDateCell.self, forCellReuseIdentifier: self.cellChartId)
        tableView.register(DetailInfoChartCell.self, forCellReuseIdentifier: self.cellDetailInfoId)
        tableView.register(NoteChartCell.self, forCellReuseIdentifier: self.cellNoteId)
        
        return tableView
    }()
    
    //MARK: Initialize
    override func setupView() {
        
        self.setupViewTitleLabel()
        self.setupviewChartTableView()
        self.setupViewNoneDataLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTappedChartView(_:)), name: NSNotification.Name.init(Notification.Name.showInfoChartView), object: nil)
    }
    
    //MARK: Handle Action
    func fetchData(_ date: Date = Date(), for patientID: String, _ title: String) {
        self.setBackItem(with: title)
        
        ChartFromToDateFacade.fetchBPOResults(date, patientID) { (results) in
            self.BPOFromToDate.setBPOResults(results)
            self.chartTableView.reloadData()
            
            if results.isEmpty {
                self.chartTableView.isHidden = true
                self.noneDataMessage.isHidden = false
            } else {
                self.chartTableView.isHidden = false
                self.noneDataMessage.isHidden = true
            }
        }
    }
    
    @objc func handleTappedChartView(_ notification: Notification) {
        if let index = notification.object as? Int {
            self.indexSelected = index
            self.chartTableView.reloadData()
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: SetupView
    func setBackItem(with name: String) {
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"),
                                           target: self,
                                           selector: #selector(backButtonPressed),
                                           title: name)
    }
    
    func setupViewTitleLabel() {
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
    
    func setupviewChartTableView() {
        self.view.addSubview(self.chartTableView)
        
        if #available(iOS 11, *) {
            self.chartTableView.snp.makeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.bottom.equalTo(self.view.safeAreaInsets)
                    .offset(-Dimension.shared.normalVerticalMargin)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.chartTableView.snp.makeConstraints { (make) in
                make.centerX.width.equalToSuperview()
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.normalVerticalMargin)
                make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    func setupViewNoneDataLabel() {
        self.view.addSubview(self.noneDataMessage)
        
        self.noneDataMessage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ChartFromToDateController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellChartId, for: indexPath) as? ChartFromDateToDateCell else { return UITableViewCell() }
            
            cell.BPOFromToDate = self.BPOFromToDate
                        
            return cell
        } else if indexPath.item == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellDetailInfoId, for: indexPath) as? DetailInfoChartCell else { return UITableViewCell() }
            
            if let index = self.indexSelected {
                cell.BPOResult = BPOFromToDate.BPOResults[index]
            } else {
                cell.BPOResult = nil
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellNoteId, for: indexPath) as? NoteChartCell else { return UITableViewCell() }
            
            
            return cell
        }
    }
    
}










