//
//  CellOptionMenu.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/25/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class CellOptionMenu: BaseCollectionViewCell {
    
    //MARK: UIControl
    private let imageIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewImageIcon()
        self.setupViewTitleLabel()
    }
    
    //MARK: Feature
    public func set(image: UIImage, title: String) {
        self.imageIcon.image = image
        self.titleLabel.text = title
    }
    
    //MARK: SetupView
    private func setupViewImageIcon() {
        self.addSubview(self.imageIcon)
        
        self.imageIcon.snp.makeConstraints { (make) in
            make.width.equalTo(18 * Dimension.shared.widthScale)
            make.height.equalTo(18 * Dimension.shared.heightScale)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
        }
    }
    
    private func setupViewTitleLabel() {
        self.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imageIcon.snp.right).offset(Dimension.shared.normalHorizontalMargin)
        }
    }
}
