//
//  NoteIconCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/3/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class NoteIconCell: BaseCollectionViewCell {
    
    //MARK: UIControl
    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let titileLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.captionFontSize)
        
        return label
    }()
    
    //MARK: Initialize
    override func setupView() {
        self.setupViewIconImage()
        self.setupViewTitileLabel()
    }
    
    func setIcon(_ icon: Icon) {
        self.titileLabel.text = icon.title
        self.iconImage.image = icon.image
    }
    
    //MARK: SetupView
    private func setupViewIconImage() {
        self.addSubview(self.iconImage)
        
        self.iconImage.snp.makeConstraints { (make) in
            make.width.equalTo(20 * Dimension.shared.widthScale)
            make.height.equalTo(8 * Dimension.shared.heightScale)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.smallHorizontalMargin)
        }
    }
    
    private func setupViewTitileLabel() {
        self.addSubview(self.titileLabel)
        
        self.titileLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.iconImage.snp.right).offset(Dimension.shared.mediumHorizontalMargin)
        }
    }
}




