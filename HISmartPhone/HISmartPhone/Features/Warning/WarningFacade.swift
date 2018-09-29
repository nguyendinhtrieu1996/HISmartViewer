//
//  WarningFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 5/14/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class WarningFacade {
    
    static func deleteBloodPressureNotifi(with key: String) {
        FirebaseAPI.DELETE_Notification(key: key)
    }
    
}
