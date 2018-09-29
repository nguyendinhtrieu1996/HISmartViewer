//
//  BloodPressureNotification.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 4/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class BloodPressureNotification: Mapper {
    
    private (set) var key: String = ""
    private (set) var patientID: String = ""
    private (set) var patientName: String = ""
    private (set) var alarmStatus: AlarmStatus = .null
    private (set) var createDate: Date = Date()
    private (set) var diastolic: Int = 0
    private (set) var systolic: Int = 0
    private (set) var pulse: Int = 0
    private (set) var isNew: Bool = false
    private (set) var userID: String = ""
    
    init() {
        
    }
    
    required init(_ data: [String : Any]) {
        patientID = data["PID_ID"] as? String ?? ""
        patientName = data["PatientName"] as? String ?? ""
        alarmStatus = AlarmStatus(rawValue: data["alarmStatus"] as? Int ?? -1) ?? .null
        createDate = (data["createDate"] as? String)?.getDate() ?? Date()
        diastolic = data["Diastolic"] as? Int ?? 0
        systolic = data["Systolic"] as? Int ?? 0
        pulse = data["Pulse"] as? Int ?? 0
        isNew = data["isNew"] as? Bool ?? false
        userID = data["UserID"] as? String ?? ""
    }
    
    func setKey(_ key: String) {
        self.key = key
    }
    
}






