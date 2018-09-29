//
//  NoteAlertView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

protocol NoteAlertViewDelegate: class {
    func closeAlert()
}

class NoteAlertView: BaseUIView {
    
    // MARK: Define variable
    weak var delegate: NoteAlertViewDelegate?
    
    // MARK: Define Control
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.text = "Lời nhắn"
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.textColor = Theme.shared.darkBlueTextColor
        label.numberOfLines = 0
        label.text = "There are many kinds of narratives and organizing principles. Science is driven by evidence gathered in experiments, and by the falsification of extant theories and their replacement with newer, asymptotically truer, ones. environment."
        return label
    }()
    
    private let closeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "clear_black"), for: .normal)
        return button
    }()
    
    // MARK: Control
    @objc private func closeButtonPress() {
        self.delegate?.closeAlert()
    }
    
    // MARK: Setup UI
    override func setupView() {
        self.setupMainView()
        self.layoutTitleLabel()
        self.layoutContentLabel()
        self.layoutCloseButton()
    }
    
    private func setupMainView(){
        self.backgroundColor = Theme.shared.defaultBGColor
        self.layer.cornerRadius = Dimension.shared.normalCornerRadius
        self.clipsToBounds = true
    }
    
    private func layoutTitleLabel() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
        }
    }
    
    private func layoutContentLabel() {
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func layoutCloseButton() {
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel)
            make.right.equalToSuperview().offset(-Dimension.shared.normalHorizontalMargin)
        }
        
        self.closeButton.addTarget(self, action: #selector(NoteAlertView.closeButtonPress), for: .touchUpInside)
    }
}
