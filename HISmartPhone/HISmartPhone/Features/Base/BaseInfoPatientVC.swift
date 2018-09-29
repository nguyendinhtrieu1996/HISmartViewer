//
//  BaseInfoPatientVC.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/25/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class BaseInfoPatientVC: BaseViewController {
    
    //MARK: UIControl
    fileprivate lazy var alertSigout: AlertAnnoucementSignoutController = {
        let alert = AlertAnnoucementSignoutController()
        
        alert.setMessage("Bạn chắc chắn \n muốn đăng xuất khỏi hệ thống")
        alert.alertDelegate = self
        
        return alert
    }()
    
    fileprivate lazy var sideMenuVC: SideMenuController = {
        let VC = SideMenuController()
        VC.delegate = self
        return VC
    }()
    
    //MARK: Initialize function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarItem()
        self.view.backgroundColor = Theme.shared.defaultBGColor
        self.setupViewNavigationBar()
        self.setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addLeftBarItem), name: NSNotification.Name.init(Notification.Name.obseverMessage), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addLeftBarItem), name: NSNotification.Name.init(Notification.Name.updateInfoUser), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupViewNavigationBar), name: NSNotification.Name.init(Notification.Name.updateNotification), object: nil)
    }
    
    //MARK: Action UIControl
    @objc func handleOptionMenu() {
        self.present(self.sideMenuVC, animated: true) {
            //
        }
    }
    
    //MARK: Action UIControl
    @objc func handleWarningItem() {
        let warningVC = WarningController()
        warningVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(warningVC, animated: true)
    }
    
    @objc func handleShareItem() {
        let shareInfoController = ShareInfoController()
        shareInfoController.patientID = HISMartManager.share.currentPatient.PID_ID
        self.navigationController?.pushViewController(shareInfoController, animated: true)
    }
    
    @objc func handleMessageItem() {
        let newMessageController = NewMessageController()
        var partnerChat = PartnerChat()
        
        if Authentication.share.typeUser == .patient {
            newMessageController.typeNewMessage = .newMesagge
        } else {
            partnerChat = PartnerChat.init(from: User.init(from: HISMartManager.share.currentPatient))
            newMessageController.typeNewMessage = .continueMessage
            newMessageController.setPartner(partnerChat)
        }
        
        newMessageController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    
    @objc func handleInfoItem() {
        let patientInformationController : PatientInformationController = PatientInformationController()
        patientInformationController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(patientInformationController, animated: true)
    }
    
    @objc func handleBackButton() {
        HISMartManager.share.resetIsShowTabbarFromSharedVC()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Feature method
    override func setupView() {
        
    }
    
    //MARK: SetupView
    @objc private func setupViewNavigationBar() {
        //NOTICE
        let warningButton = SSBadgeButton()
        warningButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        warningButton.setImage(UIImage(named: "warning"), for: .normal)
        warningButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 4)
        warningButton.badge = "\(BloodPressureNotifiHelper.shared.newBPNotifications.count)"
        warningButton.addTarget(self, action: #selector(handleWarningItem), for: .touchUpInside)
        let warningItem = UIBarButtonItem(customView: warningButton)
        
        //SHARE
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage(named: "share_patient"), for: .normal)
        shareButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        shareButton.addTarget(self, action: #selector(handleShareItem), for: .touchUpInside)
        let shareItem = UIBarButtonItem(customView: shareButton)
        
        //MESSAGE
        let messageButton = UIButton(type: .custom)
        messageButton.setImage(UIImage(named: "message_patient"), for: .normal)
        messageButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        messageButton.addTarget(self, action: #selector(handleMessageItem), for: .touchUpInside)
        let messageItem = UIBarButtonItem(customView: messageButton)
        
        //INFO
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(UIImage(named: "infor_patient"), for: .normal)
        infoButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        infoButton.addTarget(self, action: #selector(handleInfoItem), for: .touchUpInside)
        let infoItem = UIBarButtonItem(customView: infoButton)
        
        if Authentication.share.typeUser == .patient {
            self.navigationItem.rightBarButtonItems = [warningItem, messageItem, infoItem]
        } else {
            self.navigationItem.rightBarButtonItems = [warningItem, shareItem, messageItem, infoItem]
        }
    }
    
    @objc private func addLeftBarItem() {
        let number = HISMartManager.share.numberNewMessages
        
        //TITLE
        let name = HISMartManager.share.currentPatient.patient_Name
        let titleItem = UIBarButtonItem(title: name, style: .plain, target: nil, action: nil)
        
        //OPTION
        if HISMartManager.share.isShowTabbarFromSharedVC {
            let backButton = UIButton(type: .custom)
            backButton.setImage(UIImage(named: "back_white"), for: .normal)
            backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
            let backItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.leftBarButtonItems = [backItem, titleItem]
        } else {
            let optionButton = SSBadgeButton()
            optionButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            optionButton.setImage(UIImage(named: "main_menu"), for: .normal)
            optionButton.badgeEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 1)
            optionButton.badge = number == 0 ? nil : number.description
            optionButton.addTarget(self, action: #selector(handleOptionMenu), for: .touchUpInside)
            let optionItem = UIBarButtonItem(customView: optionButton)
            
            self.navigationItem.leftBarButtonItems = [optionItem, titleItem]
        }
       
    }
    
}

//MARK: - SideMenuControllerDelegate
extension BaseInfoPatientVC: SideMenuControllerDelegate {
    
    func popToListPatient() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentVC(_ vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectLogout() {
        self.present(self.alertSigout, animated: true, completion: nil)
    }
    
}

//MARK: - AlertAnnoucementSignoutControllerDelegate
extension BaseInfoPatientVC: AlertAnnoucementSignoutControllerDelegate {
    
    func didSelectSignOut() {
        Authentication.share.signOut()
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = UINavigationController(rootViewController: LoginController())
    }
    
}




