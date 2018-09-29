//
//  MainDoctor.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 2/7/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class MainDoctor: Mapper {
    
    private (set) var doctorID: String
    private (set) var fullName: String
    
    init() {
        self.doctorID = ""
        self.fullName = ""
    }
    
    required init(_ data: [String : Any]) {
        self.doctorID = data["DoctorID"] as? String ?? ""
        self.fullName = data["FullName"] as? String ?? ""
    }
    
}
