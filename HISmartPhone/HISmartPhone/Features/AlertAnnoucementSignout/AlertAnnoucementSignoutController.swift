//
//  AlertAnnoucementSignoutController.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/29/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

protocol AlertAnnoucementSignoutControllerDelegate: class {
    func didSelectSignOut()
}

class AlertAnnoucementSignoutController: AlertDeleteController {
    
    weak var alertDelegate: AlertAnnoucementSignoutControllerDelegate?
    
    //MARK: Initialize
    override func setupView() {
        super.setupView()
        
    }
    
    override func handleAcceptButton() {
        self.alertDelegate?.didSelectSignOut()
    }
    
}
