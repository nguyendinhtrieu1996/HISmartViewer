//
//  DetailPatientGuideCell.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/26/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class DetailPatientGuideCell: BaseTableViewCell {
    
    weak var diagnose: Diagnose? {
        didSet {
            self.contentLabel1.text = self.diagnose?.solution
            self.contentLabel2.text = self.diagnose?.solve
            self.contentLabel3.text = self.diagnose?.advice
        }
    }
    
    //MARK: UIControl
    private let titleLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "Hướng xử lý:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let contentLabel1: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        
        label.text = "Xử lí:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let contentLabel2: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let titleLabel3: UILabel = {
        let label = UILabel()
        
        label.text = "Lời dặn:"
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize, weight: UIFont.Weight.medium)
        
        return label
    }()
    
    private let contentLabel3: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        label.numberOfLines = 0
        
        return label
    }()

    //MARK: Initialize
    override func setupView() {
        self.setupViewTitle1()
        self.setupViewContentLabel1()
        self.setupViewTitleLabel2()
        self.setupViewContentLabel2()
        self.setupViewTitleLabel3()
        self.setupViewContentLabel3()
    }
    
    //MARK: Feature
    
    //MARK: SetupView
    private func setupViewTitle1() {
        self.addSubview(self.titleLabel1)
        
        if #available(iOS 11, *) {
            self.titleLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide)
                    .offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            }
        } else {
            self.titleLabel1.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(Dimension.shared.normalHorizontalMargin)
                make.top.equalToSuperview().offset(Dimension.shared.largeVerticalMargin)
            }
        }
    }
    
    private func setupViewContentLabel1() {
        self.addSubview(self.contentLabel1)
        
        if #available(iOS 11, *) {
            self.contentLabel1.snp.makeConstraints { (make) in
                make.left.equalTo(self.safeAreaLayoutGuide).offset(132 * Dimension.shared.widthScale)
                make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
                make.top.equalTo(self.titleLabel1)
            }
        } else {
            self.contentLabel1.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(132 * Dimension.shared.widthScale)
                make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
                make.top.equalTo(self.titleLabel1)
            }
        }
    }
    
    private func setupViewTitleLabel2() {
        self.addSubview(self.titleLabel2)
        
        self.titleLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel1)
            make.top.equalTo(self.contentLabel1.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewContentLabel2() {
        self.addSubview(self.contentLabel2)
        
        self.contentLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentLabel1)
            make.top.equalTo(self.titleLabel2)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
        }
    }
    
    private func setupViewTitleLabel3() {
        self.addSubview(self.titleLabel3)
        
        self.titleLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel1)
            make.top.equalTo(self.contentLabel2.snp.bottom).offset(Dimension.shared.largeVerticalMargin)
        }
    }
    
    private func setupViewContentLabel3() {
        self.addSubview(self.contentLabel3)
        
        self.contentLabel3.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentLabel2)
            make.top.equalTo(self.titleLabel3)
            make.right.equalToSuperview().offset(-Dimension.shared.mediumHorizontalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin)
        }
    }
   
}





