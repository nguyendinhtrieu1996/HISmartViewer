//
//  UserRegister.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/9/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

struct BloodPressure {
    var low: Int
    var preHigh: Int
    var high: Int

    mutating func setValue(low: Int, preHigh: Int, high: Int) {
        self.low = low
        self.preHigh = preHigh
        self.high = high
    }

    func CheckValue() -> Bool {
        if self.low <= 0 { return false }
        if self.preHigh <= 0 { return false }
        if self.high <= 0 { return false }
        if self.low > 500 { return false }
        if self.preHigh > 500 { return false }
        if self.high > 500 { return false }
        return true
    }
}

class Patient: Mapper {

    private (set) var PID_ID: String
    private (set) var patient_ID: String
    private (set) var patient_Password: String
    private (set) var patient_Name: String
    private (set) var birth_Date: Date
    private (set) var address_ID: Int
    private (set) var idCard_Number: Int
    private (set) var sex_ID: Gender
    private (set) var occupation: String
    private (set) var mobile_Phone: String
    private (set) var email: String
    private (set) var status: Int
    private (set) var image: String
    private (set) var remove: Int
    private (set) var access_Lasttime: Date
    private (set) var access_Status: String
    private (set) var acc_Status: String
    private (set) var alarmStatus: AlarmStatus
    private (set) var bloodType: String
    private (set) var TBPM_ID: String
    private (set) var lowSystolic: Int
    private (set) var lowDiastolic: Int
    private (set) var preHighSystolic: Int
    private (set) var preHighDiastolic: Int
    private (set) var highSystolic: Int
    private (set) var highDiastolic: Int

    private (set) var BPOPatient: BPOPatient?
    private (set) var address: Address?
    private (set) var doctorsFollow: [User]?
    private (set) var mainDoctor: MainDoctor?

    init() {
        self.PID_ID = ""
        self.patient_ID = ""
        self.patient_Password = ""
        self.patient_Name = ""
        self.birth_Date = Date()
        self.address_ID = 0
        self.idCard_Number = 0
        self.sex_ID = .male
        self.occupation = ""
        self.mobile_Phone = ""
        self.email = ""
        self.status = 0
        self.acc_Status = ""
        self.image = ""
        self.remove = 0
        self.access_Status = ""
        self.access_Lasttime = Date()
        self.alarmStatus = AlarmStatus.low
        self.bloodType = ""
        self.TBPM_ID = ""
        self.lowSystolic = 0
        self.lowDiastolic = 0
        self.preHighSystolic = 0
        self.preHighDiastolic = 0
        self.highSystolic = 0
        self.highDiastolic = 0
    }

    init(from data: Patient) {
        self.PID_ID = data.PID_ID
        self.patient_ID = data.patient_ID
        self.patient_Password = data.patient_Password
        self.patient_Name = data.patient_Name
        self.birth_Date = data.birth_Date
        self.address_ID = data.address_ID
        self.idCard_Number = data.idCard_Number
        self.sex_ID = data.sex_ID
        self.occupation = data.occupation
        self.mobile_Phone = data.mobile_Phone
        self.email = data.email
        self.status = data.status
        self.acc_Status = data.acc_Status
        self.image = data.image
        self.remove = data.remove
        self.access_Status = data.access_Status
        self.access_Lasttime = data.access_Lasttime
        self.alarmStatus = data.alarmStatus
        self.bloodType = data.bloodType
        self.TBPM_ID = data.TBPM_ID
        self.lowSystolic = data.lowSystolic
        self.lowDiastolic = data.lowDiastolic
        self.preHighSystolic = data.preHighSystolic
        self.preHighDiastolic = data.preHighDiastolic
        self.highSystolic = data.highSystolic
        self.highDiastolic = data.highDiastolic
        self.address = data.address
        self.BPOPatient = data.BPOPatient
        self.doctorsFollow = data.doctorsFollow
    }

    required init(_ data: [String : Any]) {
        self.PID_ID = data["PID_ID"] as? String ?? ""
        self.patient_ID = data["Patient_ID"] as? String ?? ""
        self.patient_Password = data["Patient_Password"] as? String ?? ""
        self.patient_Name = data["Patient_Name"] as? String ?? ""
        self.birth_Date = (data["Birth_Date"] as? String ?? "").getDate()
        self.idCard_Number = data["IdCard_Number"] as? Int ?? 0
        self.address_ID = data["Address_ID"] as? Int ?? 0
        self.sex_ID = Gender(rawValue: data["Sex_ID"] as? Int ?? 0) ?? .male
        self.occupation = data["Occupation"] as? String ?? ""
        self.mobile_Phone = data["Mobile_Phone"] as? String ?? ""
        self.email = data["Email"] as? String ?? ""
        self.status = data["Status"] as? Int ?? 0
        self.image = data["Image"] as? String ?? ""
        self.remove = data["Remove"] as? Int ?? 0
        self.access_Lasttime = (data["Access_LastTime"] as? String ?? "").getDate()
        self.access_Status = data["Acc_Status"] as? String ?? ""
        self.alarmStatus  = AlarmStatus(rawValue: data["AlarmStatus"] as? Int ?? 0) ?? .null
        self.bloodType = data["BloodType"] as? String ?? ""
        self.TBPM_ID = data["TBPM_ID"] as? String ?? ""
        self.lowSystolic = data["LowSystolic"] as? Int ?? 0
        self.lowDiastolic = data["LowDiastolic"] as? Int ?? 0
        self.preHighSystolic = data["PreHighSystolic"] as? Int ?? 0
        self.preHighDiastolic = data["PreHighDiastolic"] as? Int ?? 0
        self.highSystolic = data["HighSystolic"] as? Int ?? 0
        self.highDiastolic = data["HighDiastolic"] as? Int ?? 0
        self.acc_Status = data["Acc_Status"] as? String ?? ""
    }

    init(from user: User) {
        self.PID_ID = user.userID
        self.patient_ID = user.userName
        self.patient_Password = user.password
        self.patient_Name = user.fullName
        self.birth_Date = Date()
        self.address_ID = 0
        self.idCard_Number = 0
        self.sex_ID = user.gender
        self.occupation = ""
        self.mobile_Phone = user.mobile_Phone
        self.email = ""
        self.status = 0
        self.image = ""
        self.remove = 0
        self.access_Status = ""
        self.access_Lasttime = Date()
        self.alarmStatus = .null
        self.bloodType = ""
        self.TBPM_ID = ""
        self.lowSystolic = 0
        self.lowDiastolic = 0
        self.preHighSystolic = 0
        self.preHighDiastolic = 0
        self.highSystolic = 0
        self.highDiastolic = 0
        self.acc_Status = ""
    }

    func setBPOPatient(_ BPOPatient: BPOPatient?) {
        self.BPOPatient = BPOPatient
    }

    func setPatientID(_ id: String) {
        self.patient_ID = id
    }

    func setPatientName(_ name: String) {
        self.patient_Name = name
    }

    func setBirthDate(_ date: Date) {
        self.birth_Date = date
    }

    func setPassword(_ pass: String) {
        self.patient_Password = pass
    }

    func setAddressID(_ id: Int) {
        self.address_ID = id
    }

    func setSexID(_ id: Gender) {
        self.sex_ID = id
    }

    func setPhoneNumber(_ phone: String) {
        self.mobile_Phone = phone
    }

    func setEmail(_ email: String) {
        self.email = email
    }

    func setAddress(_ address: Address?) {
        self.address = address
    }

    func setDoctorsFollow(_ data: [User]) {
        self.doctorsFollow = data
    }
    
    func setMainDoctor(_ doctor: MainDoctor?) {
        self.mainDoctor = doctor
    }

    //MARK: GET
    func isFillAllInfo() -> Bool {
        if self.patient_ID == "" || self.patient_Name == "" || self.birth_Date == Date() || self.address_ID == 0 || self.mobile_Phone == "" || self.email == "" {
            return false
        }
        return true
    }

    func setSystolic(bloodPressure: BloodPressure) {
        self.lowSystolic = bloodPressure.low
        self.preHighSystolic = bloodPressure.preHigh
        self.highSystolic = bloodPressure.high
    }

    func setDiastolic(bloodPressure: BloodPressure) {
        self.lowDiastolic = bloodPressure.low
        self.preHighDiastolic = bloodPressure.preHigh
        self.highDiastolic = bloodPressure.high
    }

    func isEqual(_ object: Patient) -> Bool {
        if self.patient_Name == object.patient_Name && self.birth_Date == object.birth_Date && self.address_ID == object.address_ID && self.mobile_Phone == object.mobile_Phone && self.email == object.email
        && self.sex_ID.rawValue == object.sex_ID.rawValue {
            return true
        }
        return false
    }

}

//MARK: - NSCopying
extension Patient: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        let patient = Patient.init(from: self)
        return patient
    }

}

//MARK: - TransfromData
extension Patient: TransfromData {

    func transformDictionaty() -> [String : Any] {
        return ["PID_ID": (self.PID_ID == "" ? arc4random_uniform(1000000000).description : self.PID_ID),
                "Patient_ID": self.patient_ID,
                "Patient_Password": self.patient_Password,
                "Patient_Name": self.patient_Name,
                "Birth_Date": self.birth_Date.getDesciption(),
                "Address_ID": self.address_ID,
                "IdCard_Number": self.idCard_Number,
                "Sex_ID": self.sex_ID.rawValue,
                "Occupation": self.occupation,
                "Mobile_Phone": self.mobile_Phone,
                "Email": self.email,
                "Status": self.status,
                "Image": self.image,
                "Remove": self.remove,
                "Access_Lasttime": self.access_Lasttime.getDesciption(),
                "Access_Status": self.acc_Status,
                "AlarmStatus": self.alarmStatus.rawValue,
                "BloodType": self.bloodType,
                "TBPM_ID": self.TBPM_ID,
                "LowSystolic": self.lowSystolic,
                "LowDiastolic": self.lowDiastolic,
                "PreHighSystolic": self.preHighSystolic,
                "PreHighDiastolic": self.preHighDiastolic,
                "HighSystolic": self.highSystolic,
                "HighDiastolic": self.highDiastolic,
                "Acc_Status": self.acc_Status
        ]
    }

    func transformDictionatyRegister() -> [String : Any] {
        return ["PID_ID": (self.PID_ID == "" ? arc4random_uniform(1000000000).description : self.PID_ID),
                "Patient_ID": self.patient_ID,
                "Patient_Password": self.patient_Password,
                "Patient_Name": self.patient_Name,
                "Birth_Date": self.birth_Date.getDesciption(),
                "Address_ID": self.address_ID,
                "IdCard_Number": self.idCard_Number,
                "Sex_ID": self.sex_ID.rawValue,
                "Occupation": self.occupation,
                "Mobile_Phone": self.mobile_Phone,
                "Email": self.email,
                "Status": self.status,
                "Image": self.image,
                "Remove": self.remove,
                "Access_Lasttime": self.access_Lasttime.getDesciption(),
                "Access_Status": self.acc_Status
        ]
    }
    
}






