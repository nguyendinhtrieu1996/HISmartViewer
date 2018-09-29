//
//  UnSharedAlertController.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//


import UIKit

protocol UnSharedAlertDelegate: class {
    func confirmUnshare(patientID: String, doctorsID: [String])
}

class UnSharedAlertController: BaseAlertViewController {
    
    // Define variable
    var sharedPatient: SharedPatient? {
        willSet {
            self.unSharedAlertView.sharedPatient = newValue
        }
    }
    
    weak var delegate: UnSharedAlertDelegate?
    
    // MARK: Define control
    private let unSharedAlertView: UnSharedAlertView = UnSharedAlertView()
    
    // MARK: Animation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Setup layout
    override func setupView() {
        self.setupNoteAlertView()
    }
    
    private func setupNoteAlertView() {
        self.view.addSubview(self.unSharedAlertView)
        self.unSharedAlertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_60)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_60)
        }
        self.unSharedAlertView.delegate = self
    }
}

// MARK: Extension
extension UnSharedAlertController: UnSharedAlertViewDelegate {
    
    func confirmUnshare(patientID: String, doctorsID: [String]) {
        self.delegate?.confirmUnshare(patientID: patientID, doctorsID: doctorsID)
        self.dismissAlert()
    }
    
    func cancel() {
        self.dismissAlert()
    }
}

