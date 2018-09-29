//
//  SideMenuCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/22/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class SideMenuCell: BaseCollectionViewCell {
    
    var isMessageCell: Bool = false {
        didSet {
            if self.isMessageCell {
                self.statusIcon.isHidden = false
            } else {
                self.statusIcon.isHidden = true
            }
        }
    }
    
    //MARK: UIControl
    private let statusIcon: UILabel = {
       let label = UILabel()
        
        label.textColor = Theme.shared.defaultTextColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Dimension.shared.smallCaptionFontSize)
        label.backgroundColor = Theme.shared.accentColor
        label.layer.cornerRadius = Dimension.shared.heightNoticeIcon / 2
        label.layer.masksToBounds = true
        label.isHidden = true
        
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageCongig = UIImageView()
        imageCongig.contentMode = .scaleAspectFit
        return imageCongig
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    //MARK: Initialize function
    override func setupView() {
        self.setupViewIconImage()
        self.setupViewTitleLabel()
        self.setupViewStatusIcon()
        self.setupViewStatusIcon()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNumberNewMessage), name: NSNotification.Name.init(Notification.Name.obseverMessage), object: nil)
    }
    
    //MARK: Feature function
    func setData(icon: SideMenuIcon) {
        self.iconImage.image = icon.icons.image
        self.titleLabel.text = icon.icons.title
        self.isMessageCell = icon.icons.isMessageIcon
        self.setNumberNewMessage()
    }
    
    
    @objc func setNumberNewMessage() {
        if self.isMessageCell {
            let number = HISMartManager.share.numberNewMessages
            
            self.statusIcon.text = number.description
            self.statusIcon.isHidden = number == 0 ? true : false
        }
    }
    
    //MARK: SetupView function
    private func setupViewIconImage() {
        self.addSubview(self.iconImage)
        
        if #available(iOS 11.0, *) {
            self.iconImage.snp.makeConstraints { (make) in
                make.width.equalTo(Dimension.shared.widthIconSideMenu)
                make.height.equalTo(Dimension.shared.heightIconSideMenu)
                make.centerY.equalToSuperview()
                make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
                    .offset(Dimension.shared.normalHorizontalMargin)
            }
        } else {
            self.iconImage.snp.makeConstraints { (make) in
                make.width.equalTo(Dimension.shared.widthIconSideMenu)
                make.height.equalTo(Dimension.shared.heightIconSideMenu)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
            }
        }
        
    }
    
    private func setupViewTitleLabel() {
        self.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.iconImage.snp.right).offset(Dimension.shared.largeVerticalMargin_32)
        }
    }
    
    private func setupViewStatusIcon() {
        self.addSubview(self.statusIcon)
        
        self.statusIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(Dimension.shared.heightNoticeIcon)
            make.right.equalTo(self.iconImage).offset(Dimension.shared.smallHorizontalMargin / 2)
            make.top.equalTo(self.iconImage).offset(-Dimension.shared.smallVerticalMargin)
        }
    }
}



