//
//  EditPrescriptionController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/28/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class EditPrescriptionController: BaseViewController {
    
    //MARK: Variable
    fileprivate let cellId = "cellId"
    
    //MARK: UIControl
    private let contentTitleView: UIView = {
        let viewConfig = UIView()
        
        viewConfig.backgroundColor = Theme.shared.primaryColor
        viewConfig.makeShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 1.0, radius: 4.0)
        
        return viewConfig
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Chỉnh sửa đơn thuốc"
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "add_box_blue"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        return button
    }()
    
    fileprivate lazy var listDrugTableView: UITableView = {
       let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Theme.shared.defaultBGColor
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(DetailPrescriptionCell.self, forCellReuseIdentifier: self.cellId)
        
        return tableView
    }()
    
    //MARK: Initialize
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewContaintTitleView()
        self.setupViewTitleLabel()
        self.setupViewDateLabel()
        self.setupViewAddButton()
        self.setupViewListDrugTableView()
    }
    
    //MARK: Hanlde UIControl
    @objc func handleCloseButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSaveButton() {
        
    }
    
    @objc func hadleAddButton() {
        let addNewDrugController = AddNewDrugController()
        self.navigationController?.pushViewController(addNewDrugController, animated: true)
    }
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        //CLOSE
        self.navigationItem.addLeftBarItem(with: UIImage(named: "clear_white"), target: self, selector: #selector(handleCloseButton), title: nil)
        
        //SAVE
        self.navigationItem.addRightBarItems(with: "LƯU", target: self, selector: #selector(handleSaveButton))
    }
    
    private func setupViewContaintTitleView() {
        self.view.addSubview(self.contentTitleView)
        
        if #available(iOS 11, *) {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightExtendNavigationBar)
                make.top.equalTo(self.view.safeAreaInsets)
            }
        } else {
            self.contentTitleView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.height.equalTo(Dimension.shared.heightExtendNavigationBar)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
        }
    }
    
    private func setupViewTitleLabel() {
        self.contentTitleView.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            make.top.equalToSuperview()
        }
    }
    
    private func setupViewDateLabel() {
        self.contentTitleView.addSubview(self.dateLabel)
        
        self.dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewAddButton() {
        self.view.addSubview(self.addButton)
        
        self.addButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20 * Dimension.shared.heightScale)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
            make.top.equalTo(self.contentTitleView.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
        
        self.addButton.addTarget(self, action: #selector(hadleAddButton), for: .touchUpInside)
    }
    
    private func setupViewListDrugTableView() {
        self.view.addSubview(self.listDrugTableView)
        
        self.listDrugTableView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.top.equalTo(self.addButton.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension EditPrescriptionController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? DetailPrescriptionCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.backgroundColor = Theme.shared.darkBGColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editDrugController = AddNewDrugController()
        self.navigationController?.pushViewController(editDrugController, animated: true)
    }
    
}










