//
//  BPOPatient.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/22/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class BPOPatient: Mapper {
    
    private (set) var HR_ID: Int
    private (set) var PID_ID: String
    private (set) var doctorID: String
    private (set) var bloodType: Int
    private (set) var height: Int
    private (set) var weight: Int
    private (set) var disease: String
    private (set) var medical_Condition: String
    private (set) var appointment_Date: Date
    private (set) var appointment_Confirm: Date
    private (set) var TBPM_ID: String
    private (set) var TECG_ID: String
    private (set) var TSPIR_ID: String
    private (set) var service_Expire_Date: Date
    private (set) var access_LastTime: Date
    private (set) var lowSystolic: Int
    private (set) var lowDiastolic: Int
    private (set) var preHighSystolic: Int
    private (set) var preHighDiastolic: Int
    private (set) var highSystolic: Int
    private (set) var highDiastolic: Int
    private (set) var alarmStatus: AlarmStatus
    
    init() {
        HR_ID = 0
        PID_ID = ""
        doctorID = ""
        bloodType = 0
        height = 0
        weight = 0
        disease = ""
        medical_Condition = ""
        appointment_Date = Date()
        appointment_Confirm = Date()
        TBPM_ID = ""
        TECG_ID = ""
        TSPIR_ID = ""
        service_Expire_Date = Date()
        access_LastTime = Date()
        lowSystolic = 0
        lowDiastolic = 0
        preHighSystolic = 0
        preHighDiastolic = 0
        highSystolic = 0
        highDiastolic = 0
        alarmStatus = AlarmStatus.low
    }
    
    required init(_ data: [String : Any]) {
        HR_ID = data["HR_ID"] as? Int ?? 0
        PID_ID = data["PID_ID"] as? String ?? ""
        doctorID = data["DoctorID"] as? String ?? ""
        bloodType = data["BloodType"] as? Int ?? 0
        height = data["Height"] as? Int ?? 0
        weight = data["Weight"] as? Int ?? 0
        disease = data["Disease"] as? String ?? ""
        medical_Condition = data["Medical_Condition"] as? String ?? ""
        appointment_Date = (data["Appointment_Date"] as? String ?? "").getDate()
        appointment_Confirm = (data["Appointment_Confirm"] as? String ?? "").getDate()
        TBPM_ID = data["TBPM_ID"] as? String ?? ""
        TECG_ID = data["TECG_ID"] as? String ?? ""
        TSPIR_ID = data["TSPIR_ID"] as? String ?? ""
        service_Expire_Date = (data["Service_Expire_Date"] as? String ?? "").getDate()
        access_LastTime = (data["Access_LastTime"] as? String ?? "").getDate()
        lowSystolic = data["LowSystolic"] as? Int ?? 0
        lowDiastolic = data["LowDiastolic"] as? Int ?? 0
        preHighSystolic = data["PreHighSystolic"] as? Int ?? 0
        preHighDiastolic = data["PreHighDiastolic"] as? Int ?? 0
        highSystolic = data["HighSystolic"] as? Int ?? 0
        highDiastolic = data["HighDiastolic"] as? Int ?? 0
        alarmStatus  = AlarmStatus(rawValue: data["AlarmStatus"] as? Int ?? 0) ?? .null
    }
    
}






