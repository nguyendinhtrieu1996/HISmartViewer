//
//  ListUserCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/31/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class ListUserCell: BaseTableViewCell {
    
    var user: User? {
        didSet {
            self.userNameLabel.text = self.user?.fullName
        }
    }
    
    //MARK: UIControl
    private let userNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let lineDevider: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.lightBlueLineDivider
        return view
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewUserNameLabel()
        self.setupViewLineDevider()
    }
    
    //MARK: SetupView
    private func setupViewUserNameLabel() {
        self.addSubview(self.userNameLabel)
        
        if #available(iOS 11, *) {
            self.userNameLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeHorizontalMargin)
                make.centerY.equalToSuperview()
            }
        } else {
            self.userNameLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin)
                make.centerY.equalToSuperview()
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




