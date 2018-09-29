//
//  ListMessageCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/30/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ListMessageCell: BaseTableViewCell {
    
    var partner: PartnerChat = PartnerChat() {
        didSet {
            self.nameLabel.text = self.partner.user.fullName
            self.dateLabel.text = self.partner.endMessage.timestamp.getTimestap()
            self.messageLabel.text = self.partner.endMessage.message
        }
    }
    
    //MARK: UIControl
    private let userImage: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(named: "account_circle")
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.textColor = Theme.shared.lightBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = Theme.shared.grayTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let lineDevider: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.lightBlueLineDivider
        return view
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewNameLabel()
        self.setupViewMessageLabel()
        self.setupViewUserImage()
        self.setupViewDateLabel()
        self.setupViewLineDevider()
    }
    
    //MARK: SetupView
    private func setupViewNameLabel() {
        self.addSubview(self.nameLabel)
        
        if #available(iOS 11, *) {
            self.nameLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide).offset(72 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.nameLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(72 * Dimension.shared.widthScale)
                make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewMessageLabel() {
        self.addSubview(self.messageLabel)
        
        self.messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Dimension.shared.mediumVerticalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewUserImage() {
        self.addSubview(self.userImage)
        
        if #available(iOS 11, *) {
            self.userImage.snp.makeConstraints { (make) in
                make.width.height.equalTo(40 * Dimension.shared.heightScale)
                make.centerY.equalToSuperview()
                make.left.equalTo(self.safeAreaLayoutGuide).offset(12 * Dimension.shared.widthScale)
            }
        } else {
            self.userImage.snp.makeConstraints { (make) in
                make.width.height.equalTo(40 * Dimension.shared.heightScale)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(12 * Dimension.shared.widthScale)
            }
        }
    }
    
    private func setupViewDateLabel() {
        self.addSubview(self.dateLabel)
        
        if #available(iOS 11, *) {
            self.dateLabel.snp.makeConstraints { (make) in
                make.right.equalTo(self.safeAreaLayoutGuide)
                    .offset(-Dimension.shared.mediumHorizontalMargin)
                make.top.equalTo(self.nameLabel)
            }
        } else {
            self.dateLabel.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
                make.top.equalTo(self.nameLabel)
            }
        }
    }
    
    private func setupViewLineDevider() {
        self.addSubview(self.lineDevider)
        
        self.lineDevider.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.height.equalTo(Dimension.shared.heightLineDivider)
        }
    }
    
}





