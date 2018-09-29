//
//  DetailDiagnoseController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/26/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class DetailDiagnoseController: BaseViewController {
    
    //MARK: Variabel
    fileprivate let cellDetailDiagnoseId = "cellDetailDiagnoseId"
    fileprivate let cellDetailPatientGuideId = "cellDetailPatientGuideId"
    
    weak var diagnose: Diagnose? {
        didSet {
            self.dateTitleLabel.text = self.diagnose?.createDate.getDescription_DDMMYYYY_WithSlash()
            self.infoTableView.reloadData()
        }
    }
    
    //MARK: UIControl
    fileprivate lazy var optionMenu: OptionMenu = {
        var menu = OptionMenu()
        
        if Authentication.share.typeUser == .patient {
            menu = OptionMenu(images: [#imageLiteral(resourceName: "show_chart_line"), #imageLiteral(resourceName: "history")], title: [                                                                                                 "Xem đồ thị huyết áp", "Xem lịch sử chuẩn đoán"])
        } else {
            menu = OptionMenu(images: [#imageLiteral(resourceName: "show_chart_line"), #imageLiteral(resourceName: "history"), #imageLiteral(resourceName: "mode_edit_blue"), #imageLiteral(resourceName: "clear_blue")], title: [                                                                                                 "Xem đồ thị huyết áp", "Xem lịch sử chuẩn đoán", "Chỉnh sửa chuẩn đoán", "Xoá chuẩn đoán"])
        }
        
        menu.delegate = self
        menu.backgroundColor = Theme.shared.defaultBGColor
        menu.layer.cornerRadius = Dimension.shared.normalCornerRadius
        menu.makeShadow(color: Theme.shared.backgroundColorShadow, opacity: 1.0, radius: 4)
        
        return menu
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Chuẩn đoán và hướng dẫn điều trị"
        label.textColor = Theme.shared.primaryColor
        label.font = UIFont.systemFont(ofSize: 18 * Dimension.shared.heightScale)
        
        return label
    }()
    
    private let dateTitleLabel: UILabel = {
        let label = UILabel()

        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let optionButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "option"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    fileprivate let floatButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "AddIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        
        if Authentication.share.typeUser == .patient {
            button.isHidden = true
        }
        
        return button
    }()
    
    fileprivate lazy var infoTableView: UITableView = {
        let tabelView = UITableView()
        
        tabelView.isScrollEnabled = false
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.separatorColor = UIColor.clear
        tabelView.backgroundColor = Theme.shared.defaultBGColor
        tabelView.estimatedRowHeight = 100
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.register(DetailDiagnoseSickCell.self, forCellReuseIdentifier: self.cellDetailDiagnoseId)
        tabelView.register(DetailPatientGuideCell.self, forCellReuseIdentifier: self.cellDetailPatientGuideId)
        
        return tabelView
    }()
    
    //MARK: Initialize function
    override func setupView() {
        self.setupViewNavigationBar()
        self.setupViewTitleLabel()
        self.setupViewDateTitleLabel()
        self.setupViewOptionButton()
        self.setupViewInfotableView()
        self.setupViewFloatButton()
        self.setupViewOptionMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupViewNavigationBar), name: NSNotification.Name.init(Notification.Name.updateInfoUser), object: nil)
    }
    
    //MARK: Action UIControl
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleWarningItem() {
        self.navigationController?.pushViewController(WarningController(), animated: true)
    }
    
    @objc func handleShareItem() {
        
    }
    
    @objc func handleMessageItem() {
        let newMessageController = NewMessageController()
        newMessageController.hidesBottomBarWhenPushed = true
        newMessageController.typeNewMessage = .continueMessage
        var partnerChat = PartnerChat()
        
        if Authentication.share.typeUser == .patient {
            partnerChat = PartnerChat(idPartner: self.diagnose?.doctorID ?? "",
                                      user: self.diagnose?.doctor ?? User(),
                                      endMessage: Message(),
                                      isNewMessage: false)
        } else {
            partnerChat = PartnerChat(idPartner: self.diagnose?.PID_ID ?? "",
                                      user: self.diagnose?.patient ?? User(),
                                      endMessage: Message(),
                                      isNewMessage: false)
        }
        
        newMessageController.setPartner(partnerChat)
        self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    
    @objc func handleInfoItem() {
        
    }
    
    @objc func handleOptionButton() {
        self.optionMenu.showOrHide()
    }
    
    @objc func handleFloatButton() {
        let addNewDiagnoseVC = AddNewDiagnoseController()
        addNewDiagnoseVC.diagnose = Diagnose()
        self.navigationController?.show(addNewDiagnoseVC, sender: nil)
    }
    
    //MARK: Feature
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    
        if UIDevice.current.orientation.isLandscape {
            self.infoTableView.isScrollEnabled = true
        } else {
            self.infoTableView.isScrollEnabled = false
        }
    }
    
    //MARK: SetupView
    @objc private func setupViewNavigationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        //BACK ITEM
//        let name = HISMartManager.share.currentPatient.patient_Name
        self.navigationItem.addLeftBarItem(with: UIImage(named: "back_white"),
                                           target: self,
                                           selector: #selector(backButtonPressed),
                                           title: "Chẩn đoán")
        
//        //NOTICE
//        let warningButton = SSBadgeButton()
//        warningButton.frame = CGRect(x: 0, y: 0, width: 36, height: 44)
//        warningButton.setImage(UIImage(named: "warning"), for: .normal)
//        warningButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 6)
//        warningButton.badge = "0"
//        warningButton.addTarget(self, action: #selector(handleWarningItem), for: .touchUpInside)
//        let warningItem = UIBarButtonItem(customView: warningButton)
//
//        //SHARE
//        let shareButton = UIButton(type: .custom)
//        shareButton.setImage(UIImage(named: "share_patient"), for: .normal)
//        shareButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        shareButton.addTarget(self, action: #selector(handleShareItem), for: .touchUpInside)
//        let shareItem = UIBarButtonItem(customView: shareButton)
//
//        //MESSAGE
//        let messageButton = UIButton(type: .custom)
//        messageButton.setImage(UIImage(named: "message_patient"), for: .normal)
//        messageButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        messageButton.addTarget(self, action: #selector(handleMessageItem), for: .touchUpInside)
//        let messageItem = UIBarButtonItem(customView: messageButton)
//
//        //INFO
//        let infoButton = UIButton(type: .custom)
//        infoButton.setImage(UIImage(named: "infor_patient"), for: .normal)
//        infoButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        infoButton.addTarget(self, action: #selector(handleShareItem), for: .touchUpInside)
//        let infoItem = UIBarButtonItem(customView: infoButton)
//
//        if Authentication.share.typeUser == .patient {
//            self.navigationItem.rightBarButtonItems = [warningItem, messageItem]
//        } else {
//            self.navigationItem.rightBarButtonItems = [warningItem, shareItem, messageItem, infoItem]
//        }
    }
    
    private func setupViewTitleLabel() {
        self.view.addSubview(self.titleLabel)
        
        if #available(iOS 11, *) {
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
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
    
    private func setupViewDateTitleLabel() {
        self.view.addSubview(self.dateTitleLabel)
        
        self.dateTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
        }
    }
    
    private func setupViewOptionButton() {
        self.view.addSubview(self.optionButton)
        
        self.optionButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            make.top.equalTo(self.titleLabel).offset(Dimension.shared.smallVerticalMargin)
            make.width.equalTo(Dimension.shared.widthOptionButton)
            make.height.equalTo(Dimension.shared.heightOptionButton)
        }
        
        self.optionButton.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
    }
    
    private func setupViewOptionMenu() {
        self.view.addSubview(self.optionMenu)
        
        if #available(iOS 11, *) {
            self.optionMenu.snp.remakeConstraints { (make) in
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                make.top.equalTo(self.dateTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.width.equalTo(Dimension.shared.widthOptionMenu)
                make.height.equalTo(0)
            }
        } else {
            self.optionMenu.snp.remakeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalTo(self.dateTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.width.equalTo(Dimension.shared.widthOptionMenu)
                make.height.equalTo(0)
            }
        }
    }
    
    private func setupViewInfotableView() {
        self.view.addSubview(self.infoTableView)
        
        if #available(iOS 11, *) {
            self.infoTableView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.dateTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.bottom.equalTo(self.view.safeAreaInsets)
                    .offset(Dimension.shared.mediumVerticalMargin)
            }
        } else {
            self.infoTableView.snp.makeConstraints { (make) in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(self.dateTitleLabel.snp.bottom)
                    .offset(Dimension.shared.normalVerticalMargin)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    .offset(Dimension.shared.mediumVerticalMargin)
            }
        }
    }
    
    private func setupViewFloatButton() {
        self.view.addSubview(self.floatButton)
        
        if #available(iOS 11, *) {
            self.floatButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthFloatButton)
                make.right.equalToSuperview().offset(-23 * Dimension.shared.widthScale)
                make.bottom.equalTo(self.view.safeAreaInsets)
                    .offset(-Dimension.shared.largeVerticalMargin)
            }
        } else {
            self.floatButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthFloatButton)
                make.right.equalToSuperview().offset(-23 * Dimension.shared.widthScale)
                make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    .offset(-Dimension.shared.largeVerticalMargin)
            }
        }
        
        self.floatButton.addTarget(self, action: #selector(handleFloatButton), for: .touchUpInside)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailDiagnoseController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellDetailDiagnoseId, for: indexPath) as? DetailDiagnoseSickCell else { return UITableViewCell() }
            
            cell.diagnose = self.diagnose
            cell.selectionStyle = .none
            cell.backgroundColor = Theme.shared.darkBGColor
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellDetailPatientGuideId, for: indexPath) as? DetailPatientGuideCell else { return UITableViewCell() }
            
            cell.diagnose = self.diagnose
            cell.selectionStyle = .none
            cell.backgroundColor = Theme.shared.darkBGColor
            
            return cell
        }
    }
    
}

//MARK: - OptionMenuDelegate
extension DetailDiagnoseController: OptionMenuDelegate {
    
    func didSelectItem(_ optionMenu: OptionMenu, at indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            let chartVC = ChartFromToDateController()
            chartVC.fetchData(self.diagnose?.createDate ?? Date(), for: self.diagnose?.PID_ID ?? "", self.diagnose?.patient.fullName ?? "")
            chartVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(chartVC, animated: true)
            break
        case 1:
            self.navigationController?.popViewController(animated: true)
            break
        case 2:
            let editDiagnoseVC = AddNewDiagnoseController()
            editDiagnoseVC.diagnose = self.diagnose?.copy() as? Diagnose ?? Diagnose()
            editDiagnoseVC.isEditDiagnose = true
            editDiagnoseVC.delegate = self
            self.navigationController?.pushViewController(editDiagnoseVC, animated: true)
            break
        case 3:
            let alertDeleteVC = AlertDeleteController()
            alertDeleteVC.delegate = self
            self.present(alertDeleteVC, animated: true, completion: nil)
            break
        default:
            break
        }
        
        self.optionMenu.hide()
    }
    
}

//MARK: - AlertDeleteDiagnoseControllerDelegate
extension DetailDiagnoseController: AlertDeleteControllerDelegate {

    func didSelectDelete() {
        DetailDiagnoseFacade.deleteDiagnose(by: self.diagnose?.id ?? 0) {
            NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateListDiagnose), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }

    func didSelectCancel() {
        //
    }

}

//MARK: - AddNewDiagnoseControllerDelegate
extension DetailDiagnoseController: AddNewDiagnoseControllerDelegate {
    
    func updateDiagnose(_ diagnose: Diagnose) {
        self.diagnose = diagnose
    }
    
}





