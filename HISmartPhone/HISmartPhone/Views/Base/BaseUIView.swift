//
//  BaseUIView.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/22/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class BaseUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
    
}
