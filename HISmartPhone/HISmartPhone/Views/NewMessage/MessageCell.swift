//
//  MessageCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/30/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class MessageCell: BaseCollectionViewCell {
    
    var message: Message = Message() {
        didSet {
            self.messageLabel.text = self.message.message
            
            if self.isShowTime {
                self.timeLabel.text = Date.getDescptionTimeForMessage(from: self.message.timestamp)
                self.timeLabel.isHidden = false
            } else {
                self.timeLabel.text = ""
                self.timeLabel.isHidden = false
            }
            
            self.setupViewTimeLabel()
            self.setupViewContaintViewMessage()
            
            self.estimatedWidth = self.message.message.estimateFrameForText(maxWidth: Dimension.shared.widthMessage, fontSize: Dimension.shared.messageFontSize).width + Dimension.shared.edgeInsetLabel
            
            if self.message.fromId == Authentication.share.currentUserId {
                self.containtViewMessage.backgroundColor = Theme.shared.ownerMessageCGColor
                self.messageLabel.textColor = Theme.shared.defaultTextColor
                self.setupViewOwnerMessage()
            } else {
                self.containtViewMessage.backgroundColor = Theme.shared.partnerMessageCGColor
                self.messageLabel.textColor = Theme.shared.darkBlueTextColor
                self.setupViewPartnerLabelMessage()
            }
        }
    }
    
    var isShowTime: Bool = false {
        didSet {
            //
        }
    }
    
    private var estimatedWidth: CGFloat = 0
    
    //MARK: UIControl
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Dimension.shared.messageFontSize)
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        
        return label
    }()
    
    private let containtViewMessage: UIView =  {
        let view = UIView()
        
        view.layer.cornerRadius = Dimension.shared.superCornerRadius
        view.layer.masksToBounds = true
        
        return view
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.addSubview(self.timeLabel)
        self.addSubview(self.containtViewMessage)
        self.addSubview(self.messageLabel)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGSize {
        let size = CGSize(width: Dimension.shared.widthMessage, height: 1000)
        let font = UIFont.systemFont(ofSize: Dimension.shared.messageFontSize)
        let attrString = NSAttributedString(string: text,
                                            attributes:[NSAttributedStringKey.font: font,
                                                        NSAttributedStringKey.foregroundColor: UIColor.white])
        
        let textHeight = attrString.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
        
        return textHeight
    }
    
    //MARK: SetupView
    private func setupViewTimeLabel() {
        self.addSubview(self.timeLabel)
        
        self.timeLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Dimension.shared.smallVerticalMargin)
        }
    }
    
    private func setupViewPartnerLabelMessage() {
        if #available(iOS 11, *) {
            self.messageLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(self.estimatedWidth)
                make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
                make.top.equalTo(self.timeLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.messageLabel.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.width.equalTo(self.estimatedWidth)
                make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
                make.top.equalTo(self.timeLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewOwnerMessage() {
        if #available(iOS 11, *) {
            self.messageLabel.snp.remakeConstraints { (make) in
                make.right.equalTo(self.safeAreaLayoutGuide)
                    .offset(Int(-Dimension.shared.largeHorizontalMargin))
                make.width.equalTo(self.estimatedWidth)
                make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
                make.top.equalTo(self.timeLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            }
        } else {
            self.messageLabel.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(Int(-Dimension.shared.largeHorizontalMargin))
                make.width.equalTo(self.estimatedWidth)
                make.bottom.equalToSuperview().offset(-Dimension.shared.mediumVerticalMargin)
                make.top.equalTo(self.timeLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            }
        }
    }
    
    private func setupViewContaintViewMessage() {
        self.containtViewMessage.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.top.equalTo(self.timeLabel.snp.bottom).offset(Dimension.shared.smallVerticalMargin)
            make.right.equalTo(self.messageLabel).offset(Dimension.shared.edgeInsetLabel)
            make.left.equalTo(self.messageLabel).offset(-Dimension.shared.edgeInsetLabel)
        }
    }
    
}









