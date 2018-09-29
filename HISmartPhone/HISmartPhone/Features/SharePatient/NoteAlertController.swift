//
//  NoteAlertController.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class NoteAlertController: BaseAlertViewController {
    
    // MARK: Define control
    private let noteAlertView: NoteAlertView = NoteAlertView()
    
    // MARK: Animation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Setup layout
    override func setupView() {
        self.setupNoteAlertView()
    }
    
    private func setupNoteAlertView() {
        self.view.addSubview(self.noteAlertView)
        self.noteAlertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_32)
        }
        
        self.noteAlertView.delegate = self
    }
}

// MARK: Extension
extension NoteAlertController: NoteAlertViewDelegate {
    func closeAlert() {
        self.dismissAlert()
    }
}
