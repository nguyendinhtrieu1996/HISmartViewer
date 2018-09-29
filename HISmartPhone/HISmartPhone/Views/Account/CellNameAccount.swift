//
//  CellNameAccount.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class CellNameAccount: BaseTableViewCell {
    
    var user: User? {
        didSet {
            if self.user?.typeUser == .doctor {
                self.usernameLabel.text = "BS. \(self.user?.fullName ?? "")"
            } else {
                self.usernameLabel.text = "BN. \(self.user?.fullName ?? "")"
            }
            
            self.codeLabel.text = self.user?.userName
        }
    }
    
    var mainDoctor: MainDoctor? {
        didSet {
            if Authentication.share.typeUser == .doctor {
                self.followDoctorLabel.text = ""
                return
            }
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal(
                    "Bs theo dõi chính: ",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize,
                    weight: UIFont.Weight.medium
                ).normal(
                    self.mainDoctor?.fullName ?? "",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize
            )
            
            self.mainDoctorLabel.attributedText = formattedString
        }
    }
    
    var followDoctor = [User]() {
        didSet {
            if Authentication.share.typeUser == .doctor {
                self.followDoctorLabel.text = ""
                return
            }
            
            var titles: String = ""
            titles += self.followDoctor.enumerated().flatMap({ (index, user) -> String in
                if index != self.followDoctor.count - 1 {
                    return "BS." + user.fullName + ", "
                } else {
                    return "BS." + user.fullName
                }
            })
            
            let formattedString = NSMutableAttributedString()
            formattedString
                .normal(
                    "Bs theo dõi phụ: ",
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize,
                    weight: UIFont.Weight.medium
                ).normal(
                    titles,
                    textColor: Theme.shared.darkBlueTextColor,
                    fontSize: Dimension.shared.bodyFontSize
            )
            
            self.followDoctorLabel.attributedText = formattedString
        }
    }

    
    //MARK: UIControl
    private let usernameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.titleFontSize)
        
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = Theme.shared.darkBlueTextColor
        label.font = UIFont.systemFont(ofSize: Dimension.shared.bodyFontSize)
        
        return label
    }()
    
    private let mainDoctorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let followDoctorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let lineDevider: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.shared.defaultBGColor
        return view
    }()
    
    //MARK: Initalize
    override func setupView() {
        self.setupViewUserNameLabel()
        self.setupViewCodeLabel()
        self.setupViewMainDoctorLabel()
        self.setupViewFollowDoctorLabel()
        self.setupViewLineDevider()
    }
    
    //MARK: SetupView
    private func setupViewUserNameLabel() {
        self.addSubview(self.usernameLabel)
        
        self.usernameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.top.equalToSuperview().offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewCodeLabel() {
        self.addSubview(self.codeLabel)
        
        self.codeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.usernameLabel)
            make.top.equalTo(self.usernameLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewMainDoctorLabel() {
        self.addSubview(self.mainDoctorLabel)
        
        self.mainDoctorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.usernameLabel)
            make.top.equalTo(self.codeLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewFollowDoctorLabel() {
        self.addSubview(self.followDoctorLabel)
        
        self.followDoctorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.usernameLabel)
            make.top.equalTo(self.mainDoctorLabel.snp.bottom).offset(Dimension.shared.normalVerticalMargin)
            make.bottom.equalToSuperview().offset(-Dimension.shared.largeVerticalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.normalVerticalMargin)
        }
    }
    
    private func setupViewLineDevider() {
        self.addSubview(self.lineDevider)
        
        self.lineDevider.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.height.equalTo(Dimension.shared.normalVerticalMargin)
        }
    }
    
}






