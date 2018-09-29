//
//  BaseAlertViewController.swift
//  StylePizza
//
//  Created by MACOS on 11/24/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class BaseAlertViewController: UIViewController {
    
    // MARK: Define controls
    internal let viewBackground: UIView = {
        let view = UIView()
        
        view.backgroundColor = Theme.shared.alertBGColor
        view.alpha = 0
        
        return view
    }()
    
    // MARK: This function is a default initialization function
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewBackground()
        self.setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setup layout
    private func setupViewBackground() {
        self.view.addSubview(self.viewBackground)
        
        self.viewBackground.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissAlert)
        )
        
        self.viewBackground.addGestureRecognizer(tapGesture)
    }
    
    func setupView() {}
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.viewBackground.alpha = 1
        }
    }
}


