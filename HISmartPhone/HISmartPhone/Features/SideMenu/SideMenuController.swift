//
//  SlideMenuController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/22/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol SideMenuControllerDelegate: class {
    func presentVC(_ vc: UIViewController)
    func popToListPatient()
    func didSelectLogout()
}

class SideMenuController: BaseAlertViewController {
    
    //MARK: Variable
    fileprivate let cellSideMenuId = "cellSideMenuId"
    fileprivate var sideMenuIcons: [SideMenuIcon] = SideMenuIcon.getIcon()
    weak var delegate: SideMenuControllerDelegate?
    
    //MARK: UIControl
    private let containView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.defaultBGColor
        return view
    }()
    
    private let topContainView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.primaryColor
        return view
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "LOGO_BLUE"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let userImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "account_circle"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.defaultTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    fileprivate lazy var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = Theme.shared.defaultBGColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SideMenuCell.self, forCellWithReuseIdentifier: self.cellSideMenuId)
        
        return collectionView
    }()
    
    //MARK: Initialize function
    override func setupView() {
        self.setupViewContainView()
        self.setupViewTopContainView()
        self.setupViewLogoImage()
        self.setupViewUserImage()
        self.setupViewUserNameLabel()
        self.setupViewCodeLabel()
        self.setupViewMenuCollectionView()
        
        self.setData()
        self.showSideMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setData), name: NSNotification.Name.init(Notification.Name.updateInfoUser), object: nil)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGesture.direction = .left
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    //MARK: - Action
    @objc private func handleSwipeGesture() {
        self.dismissAlert()
    }
    
    //MARK: Feature function
    @objc private func setData() {
        self.userNameLabel.text = Authentication.share.currentUser?.fullName
        self.codeLabel.text = Authentication.share.currentUser?.userName
        self.sideMenuIcons = SideMenuIcon.getIcon()
        self.menuCollectionView.reloadData()
    }
    
    private func showSideMenu() {
        let tx = Dimension.shared.widthSideMenu
        
        UIView.animate(withDuration: 1.5, delay: 0.05, options: UIViewAnimationOptions.curveLinear, animations: {
            self.containView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, tx, 0, 0)
        }) { (finish) in
            //
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: SetupView function
    private func setupViewContainView() {
        self.view.addSubview(self.containView)
        
        self.containView.snp.makeConstraints { (make) in
            make.height.centerY.equalToSuperview()
            make.width.equalTo(Dimension.shared.widthSideMenu)
            make.right.equalTo(self.view.snp.left)
        }
    }
    
    private func setupViewTopContainView() {
        self.containView.addSubview(self.topContainView)
        
        self.topContainView.snp.makeConstraints { (make) in
            make.width.centerX.top.equalToSuperview()
            make.height.equalTo(121 * Dimension.shared.heightScale)
        }
    }
    
    private func setupViewLogoImage() {
        self.containView.addSubview(self.logoImage)
        
        if #available(iOS 11.0, *) {
            self.logoImage.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    .offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.logoImage.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewUserImage() {
        self.containView.addSubview(self.userImage)
        
        if #available(iOS 11.0, *) {
            self.userImage.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthUserImage)
                make.left.equalTo(self.containView.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                
                make.bottom.equalTo(self.topContainView).offset(-Dimension.shared.mediumVerticalMargin)
            }
        } else {
            self.userImage.snp.makeConstraints { (make) in
                make.width.height.equalTo(Dimension.shared.widthUserImage)
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.bottom.equalTo(self.topContainView).offset(-Dimension.shared.mediumVerticalMargin)
            }
        }
    }
    
    private func setupViewUserNameLabel() {
        self.containView.addSubview(self.userNameLabel)
        
        self.userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.userImage.snp.right).offset(Dimension.shared.normalHorizontalMargin)
            make.top.equalTo(self.userImage).offset(-Dimension.shared.smallVerticalMargin)
        }
    }
    
    private func setupViewCodeLabel() {
        self.containView.addSubview(self.codeLabel)
        
        self.codeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.userNameLabel)
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupViewMenuCollectionView() {
        self.containView.addSubview(self.menuCollectionView)
        
        self.menuCollectionView.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(self.topContainView.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.bottom.equalToSuperview()
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SideMenuController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sideMenuIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellSideMenuId, for: indexPath) as? SideMenuCell else { return UICollectionViewCell() }
    
        cell.setData(icon: self.sideMenuIcons[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 56 * Dimension.shared.heightScale)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch self.sideMenuIcons[indexPath.item].childMenu {
        case .account:
            self.delegate?.presentVC(AccountController())
            break
        case .listPatient:
            self.dismissAlert()
            self.delegate?.popToListPatient()
            return
        case .message:
            self.delegate?.presentVC(MessageBoxController())
            break
        case .shared:
            let sharePatientController = SharePatientController()
            sharePatientController.shareType = ShareType.Shared
            self.delegate?.presentVC(sharePatientController)
            break
        case .sharedToPatient:
            let sharePatientController = SharePatientController()
            sharePatientController.shareType = ShareType.BeShared
            self.delegate?.presentVC(sharePatientController)
            break
        case .sigout:
            self.dismissAlert()
            self.delegate?.didSelectLogout()
            return
        }
        
        self.dismissAlert()
    }
    
}




