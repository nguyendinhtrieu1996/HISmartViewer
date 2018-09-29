//
//  ShareInfoPatientAlert.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class ShareInfoPatientAlert: BaseAlertViewController {
    
    // MARK: Define variable
    var patientBeShared: PatientBeShared? {
        willSet {
            guard let value = newValue else {
                return
            }
            self.shareInfoPatientAlertView.setValue(patientBeShared: value)
        }
    }
    
    // MARK: Define controls
    private let shareInfoPatientAlertView = ShareInfoPatientAlertView()
    
    // MARK: Setup UI
    override func setupView() {
        self.setupAlertView()
    }
    
    private func setupAlertView() {
        self.view.addSubview(self.shareInfoPatientAlertView)
        self.shareInfoPatientAlertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.shared.largeHorizontalMargin_32)
            make.right.equalToSuperview().offset(-Dimension.shared.largeHorizontalMargin_32)
            make.height.lessThanOrEqualToSuperview()
        }
        self.shareInfoPatientAlertView.delegate = self
    }
    
    override func dismissAlert() {
        self.dismiss(animated: true) {
            BeSharedManager.share.isShow = false
        }
    }
}

// MARK: Extension
extension ShareInfoPatientAlert: ShareInfoPatientAlertViewDelegate {
    func handleCloseAlert() {
        self.dismissAlert()
    }
}
