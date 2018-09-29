//
//  BaseScrollView.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/22/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

// This class is a base for UIView can scroll
class BaseScrollView: UIScrollView {
    
    // MARK: Define variable
    let view: UIView = UIView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Theme.shared.defaultBGColor
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup layout
    func setupView() {
        self.addSubview(self.view)
        self.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        self.view.backgroundColor = UIColor.clear
    }
}









