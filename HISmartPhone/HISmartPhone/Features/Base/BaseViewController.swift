//
//  BaseViewController.swift
//  HISmartPhone
//
//  Created by MACOS on 12/19/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.shared.defaultBGColor
        self.setupView()
    }
    
    func setupView() {
        
    }
    
}
