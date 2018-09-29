//
//  ListDrugAddedCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/27/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol ListDrugAddedCellDelegate: class {
    func didSelectAddDrugButton()
}

class ListDrugAddedCell: BaseCollectionViewCell {
    
    weak var delegate: ListDrugAddedCellDelegate?
    fileprivate let cellId = "cellId"
    
    //MARK: UIControl
    private let addDrugButton: ButtonWidthImage = {
        let button = ButtonWidthImage(title: "Tiếp tục thêm thuốc",
                                      image: "arrow_up",
                                      widthImage: 10 * Dimension.shared.widthScale,
                                      fontSize: Dimension.shared.bodyFontSize)
        
        button.backgroundColor = Theme.shared.accentColor
        button.layer.cornerRadius = Dimension.shared.defaultHeightButton / 2
        button.layer.masksToBounds = true
        
        return button
    }()
    
    fileprivate lazy var infoTableView: UITableView = {
        let tabelView = UITableView()
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.separatorColor = UIColor.clear
        tabelView.backgroundColor = Theme.shared.defaultBGColor
        tabelView.estimatedRowHeight = 100
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.register(DetailPrescriptionCell.self, forCellReuseIdentifier: self.cellId)
        
        return tabelView
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewAddDrugButton()
        self.setupViewInfoTableView()
    }
    
    //MARK: Handle UIControl
    @objc func handleAddDrugButton() {
        self.delegate?.didSelectAddDrugButton()
    }
    
    //MARK: SetupView
    private func setupViewAddDrugButton() {
        self.addSubview(self.addDrugButton)
        
        self.addDrugButton.snp.makeConstraints { (make) in
            make.width.equalTo(Dimension.shared.mediumWidthButton)
            make.height.equalTo(Dimension.shared.defaultHeightButton)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
        }
        
        self.addDrugButton.addTarget(self, action: #selector(handleAddDrugButton), for: .touchUpInside)
    }
    
    private func setupViewInfoTableView() {
        self.addSubview(self.infoTableView)
        
        self.infoTableView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.top.equalTo(self.addDrugButton.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ListDrugAddedCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? DetailPrescriptionCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}








