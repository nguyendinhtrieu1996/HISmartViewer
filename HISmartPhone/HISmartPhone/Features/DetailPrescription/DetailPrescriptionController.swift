//
//  DetailPrescriptionController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/27/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class DetailPrescriptionController: BaseViewController {
    
    //MARK: Variable
    fileprivate let cellId = "cellId"
    fileprivate var indexEdit: Int?
    
    var prescription: Prescription? {
        didSet {
            let dateTime = self.prescription?.createDate.getDescription_DDMMYYYY_WithSlash() ?? ""
            self.dateLabel.text = (self.prescription?.prescriptionCode ?? "") + " - \(dateTime)"
            self.nameTitleLabel.text = "BS. \(self.prescription?.doctor.fullName ?? "")"
            self.fetchData(self.prescription?.prescriptionCode ?? "")
        }
    }
    
    fileprivate var listPrescription = [Prescription]()
    fileprivate var idDelete: Int = 0
    
    public lazy var alertDeleteVC: AlertDeleteController = {
        let alert = AlertDeleteController()
        
        alert.delegate = self
        alert.setMessage("Bạn chắc chắn muốn \n xoá đơn thuốc này")
        
        return alert
    }()
    
    //MARK: UIControl
    fileprivate lazy var alertAppreciate: AppreciatePresciptionController = {
        let alert = AppreciatePresciptionController()
        alert.delegate = self
        return alert
    }()
    
    fileprivate lazy var optionMenu: OptionMenu = {
        var menu = OptionMenu()
        
        menu = OptionMenu(images: [#imageLiteral(resourceName: "show_chart_line"), #imageLiteral(resourceName: "history")],
                          title: [                                                                                                 "Xem đồ thị huyết áp", "Xem lịch sử đơn thuốc"])
        menu.delegate = self
        menu.backgroundColor = Theme.shared.defaultBGColor
        menu.layer.cornerRadius = Dimension.shared.normalCornerRadius
        menu.makeShadow(color: Theme.shared.backgroundColorShadow, opacity: 1.0, radius: 4)
        
        return menu
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        
        return label
    }()
    
    private let nameTitleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    public let optionButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "option"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
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
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewDateLabel()
        self.setupViewNameLabel()
        self.setupViewOptionButton()
        
        self.setupViewListDrugTableView()
        self.setupViewOptionMenu()
        
    }
    
    //MARK: Handle Action
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleOptionButton() {
        self.optionMenu.showOrHide()
    }
    
    //MARK: Feature
    private func fetchData(_ code: String) {
        DetailPrescriptionFacade.fetchAllDrug(of: code) { (prescriptions) in
            self.listPrescription = prescriptions
            self.listDrugTableView.reloadData()
        }
    }
    
    //MARK: SetupView
    private func setupViewNavigationBar() {
        let patientname = HISMartManager.share.currentPatient.patient_Name
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"),
                                           target: self,
                                           selector: #selector(backButtonPressed),
                                           title: "Đơn thuốc BN.\(patientname)")
    }
    
    private func setupViewDateLabel() {
        self.view.addSubview(self.dateLabel)
        
        if #available(iOS 11, *) {
            self.dateLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.view.safeAreaInsets)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.dateLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewNameLabel() {
        self.view.addSubview(self.nameTitleLabel)
        
        self.nameTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.dateLabel)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewOptionButton() {
        self.view.addSubview(self.optionButton)
        
        self.optionButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            make.top.equalTo(self.dateLabel).offset(Dimension.shared.smallVerticalMargin)
            make.width.equalTo(Dimension.shared.widthOptionButton)
            make.height.equalTo(Dimension.shared.heightOptionButton)
        }
        
        self.optionButton.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
    }
    
    private func setupViewOptionMenu() {
        self.view.addSubview(self.optionMenu)
        
        self.optionMenu.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalTo(self.nameTitleLabel.snp.bottom)
                .offset(Dimension.shared.normalVerticalMargin)
            make.width.equalTo(Dimension.shared.widthOptionMenu)
            make.height.equalTo(0)
        }
    }
    
    
    private func setupViewListDrugTableView() {
        self.view.addSubview(self.listDrugTableView)
        
        if #available(iOS 11, *) {
            self.listDrugTableView.snp.makeConstraints({ (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.nameTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.bottom.equalTo(self.view.safeAreaInsets)
                    .offset(-Dimension.shared.normalVerticalMargin)
            })
        } else {
            self.listDrugTableView.snp.makeConstraints({ (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.nameTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.normalVerticalMargin)
            })
        }
    }
    
}

//MARK: - UITableViewDelegate
extension DetailPrescriptionController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if Authentication.share.typeUser == .doctor {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let evaluation = UITableViewRowAction(style: .normal, title: "Đánh giá") { action, index in
            self.indexEdit = index.item
            let prescription = self.listPrescription[index.item]
            self.alertAppreciate.message = prescription.evaluation
            self.present(self.alertAppreciate, animated: true, completion: {
                //
            })
        }
        
        evaluation.backgroundColor = Theme.shared.accentColor
        
        let update = UITableViewRowAction(style: .normal, title: "Chỉnh sửa") { action, index in
            let editPrescriptionVC = AddNewDrugController()
            editPrescriptionVC.hidesBottomBarWhenPushed = true
            editPrescriptionVC.titleText = "Sửa đơn thuốc"
            editPrescriptionVC.prescription = self.listPrescription[indexPath.item].copy() as? Prescription ?? Prescription()
            editPrescriptionVC.isEditPrescription = true
            editPrescriptionVC.delegate = self
            self.navigationController?.pushViewController(editPrescriptionVC, animated: true)
        }
        
        update.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        return [update, evaluation]
    }
    
}

//MARK: - UITableViewDataSource
extension DetailPrescriptionController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listPrescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? DetailPrescriptionCell else { return UITableViewCell() }
        
        cell.orderNumber = (indexPath.item + 1)
        cell.prescription = self.listPrescription[indexPath.item]
        
        return cell
    }
    
}

//MARK: - OptionMenuDelegate
extension DetailPrescriptionController: OptionMenuDelegate {
    
    func didSelectItem(_ optionMenu: OptionMenu, at indexPath: IndexPath) {
        self.optionMenu.hide()
        
        switch indexPath.item {
        case 0:
            let chartVC = ChartFromToDateController()
            let prescription = self.listPrescription.first ?? Prescription()
            
            chartVC.fetchData(prescription.createDate, for: prescription.PID_ID, self.prescription?.patient.fullName ?? "")
            chartVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(chartVC, animated: true)
            break
        case 1:
            self.navigationController?.popViewController(animated: true)
            break
        default:
            break
        }
    }
    
}

//MARK: - AlertDeleteControllerDelegate
extension DetailPrescriptionController: AlertDeleteControllerDelegate {
    
    func didSelectDelete() {
        DetailPrescriptionFacade.deletePrescription(by: self.listPrescription[self.idDelete].id) {
            NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateListPrescription), object: nil)
            self.fetchData(self.prescription?.prescriptionCode ?? "")
        }
    }
    
    func didSelectCancel() {
        
    }
    
}

//MARK: - AddNewPrescriptionCellDelegate
extension DetailPrescriptionController: AddNewDrugControllerDelegate {
    
    func didEndEditPrescription(_ prescription: Prescription) {
        NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateListPrescription), object: nil)
        self.fetchData(self.prescription?.prescriptionCode ?? "")
    }
    
}

//MARK: - AppreciatePresciptionControllerDelegate
extension DetailPrescriptionController: AppreciatePresciptionControllerDelegate {
    
    func saveAppreciate(_ message: String) {
        guard let index = self.indexEdit else { return }
        let prescription = self.listPrescription[index]
        
        prescription.setEvaluation(message)
        AddNewDrugFacade.postPrescription(prescription: prescription, completionHandler: {
            NotificationCenter.default.post(name:
                NSNotification.Name.init(Notification.Name.updateListPrescription), object: nil)
            
            self.fetchData(self.prescription?.prescriptionCode ?? "")
        }, errorHandler: {
            //ERROR
        })
    }
    
}


