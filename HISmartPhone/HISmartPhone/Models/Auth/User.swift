//
//  Patient.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/8/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class User: NSObject, Mapper, NSCoding {
    
    private (set) var userID: String
    private (set) var userName: String
    private (set) var password: String
    private (set) var fullName: String
    private (set) var gender: Gender
    private (set) var medicalCenterID: String
    private (set) var departmentId: Int
    private (set) var mobile_Phone: String
    private (set) var doctor_Degree: String
    private (set) var rankId: Int
    private (set) var status: String
    private (set) var doctorAssistant_Enable: String
    private (set) var access_LastTime: Date
    private (set) var acc_Status: String
    private (set) var typeUser: TypeUser
    
    override init() {
        self.userID = ""
        self.userName = ""
        self.password = ""
        self.fullName = ""
        self.gender = .male
        self.medicalCenterID = ""
        self.departmentId = 0
        self.mobile_Phone = ""
        self.doctor_Degree = ""
        self.rankId = 0
        self.status = ""
        self.doctorAssistant_Enable = ""
        self.access_LastTime = Date()
        self.acc_Status = ""
        self.typeUser = .patient
        super.init()
    }
    
    required init(_ data: [String : Any]) {
        self.userID = data["UserID"] as? String ?? ""
        self.userName = data["UserName"] as? String ?? ""
        self.password = data["Password"] as? String ?? ""
        self.fullName = data["FullName"] as? String ?? ""
        self.gender = Gender(rawValue: data["Gender"] as? Int ?? 0) ?? .male
        self.medicalCenterID = data["MedicalCenterID"] as? String ?? ""
        self.departmentId = data["DepartmentId"] as? Int ?? 0
        self.mobile_Phone = data["Mobile_Phone"] as? String ?? ""
        self.doctor_Degree = data["Doctor_Degree"] as? String ?? ""
        self.rankId = data["RankId"] as? Int ?? 0
        self.status = data["Status"] as? String ?? ""
        self.doctorAssistant_Enable = data["DoctorAssistant_Enable"] as? String ?? ""
        self.access_LastTime = (data["Access_LastTime"] as? String ?? "").getDate()
        self.acc_Status = data["Acc_Status"] as? String ?? ""
        self.typeUser = TypeUser(rawValue: data["TypeUser"] as? String ?? "") ?? .patient
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userID = aDecoder.decodeObject(forKey: "UserID") as? String ?? ""
        self.userName = aDecoder.decodeObject(forKey: "UserName") as? String ?? ""
        self.password = aDecoder.decodeObject(forKey: "Password") as? String ?? ""
        self.fullName = aDecoder.decodeObject(forKey: "FullName") as? String ?? ""
        self.gender = Gender(rawValue: aDecoder.decodeInteger(forKey: "Gender")) ?? .male
        self.medicalCenterID = aDecoder.decodeObject(forKey: "MedicalCenterID") as? String ?? ""
        self.departmentId = aDecoder.decodeInteger(forKey: "DepartmentId")
        self.mobile_Phone = aDecoder.decodeObject(forKey: "Mobile_Phone") as? String ?? ""
        self.doctor_Degree = aDecoder.decodeObject(forKey: "Doctor_Degree") as? String ?? ""
        self.rankId = aDecoder.decodeInteger(forKey: "RankId")
        self.status = aDecoder.decodeObject(forKey: "Status") as? String ?? ""
        self.doctorAssistant_Enable = aDecoder.decodeObject(forKey: "DoctorAssistant_Enable") as? String ?? ""
        self.access_LastTime = (aDecoder.decodeObject(forKey: "Access_LastTime") as? String ?? "").getDate()
        self.acc_Status = aDecoder.decodeObject(forKey: "Acc_Status") as? String ?? ""
        self.typeUser = TypeUser(rawValue: aDecoder.decodeObject(forKey: "TypeUser") as? String ?? "") ?? .patient
        
    }
    
    init(from patient: Patient) {
        self.userID = patient.PID_ID
        self.userName = patient.patient_ID
        self.password = patient.patient_Password
        self.fullName = patient.patient_Name
        self.gender = patient.sex_ID
        self.medicalCenterID = ""
        self.departmentId = 0
        self.mobile_Phone = patient.mobile_Phone
        self.doctor_Degree = ""
        self.rankId = 0
        self.status = ""
        self.doctorAssistant_Enable = ""
        self.access_LastTime = Date()
        self.acc_Status = ""
        self.typeUser = .patient
        super.init()
    }
    
    init(from data: User) {
        self.userID = data.userID
        self.userName = data.userName
        self.password = data.password
        self.fullName = data.fullName
        self.gender = data.gender
        self.medicalCenterID = data.medicalCenterID
        self.departmentId = data.departmentId
        self.mobile_Phone = data.mobile_Phone
        self.doctor_Degree = data.doctor_Degree
        self.rankId = data.rankId
        self.status = data.status
        self.doctorAssistant_Enable = data.doctorAssistant_Enable
        self.access_LastTime = data.access_LastTime
        self.acc_Status = data.acc_Status
        self.typeUser = data.typeUser
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: "UserID")
        aCoder.encode(self.userName, forKey: "UserName")
        aCoder.encode(self.password, forKey: "Password")
        aCoder.encode(self.fullName, forKey: "FullName")
        aCoder.encode(self.gender.rawValue, forKey: "Gender")
        aCoder.encode(self.medicalCenterID, forKey: "MedicalCenterID")
        aCoder.encode(self.departmentId, forKey: "DepartmentId")
        aCoder.encode(self.mobile_Phone, forKey: "Mobile_Phone")
        aCoder.encode(self.doctor_Degree, forKey: "Doctor_Degree")
        aCoder.encode(self.rankId, forKey: "RankId")
        aCoder.encode(self.status, forKey: "Status")
        aCoder.encode(self.doctorAssistant_Enable, forKey: "DoctorAssistant_Enable")
        aCoder.encode(self.access_LastTime, forKey: "Access_LastTime")
        aCoder.encode(self.acc_Status, forKey: "Acc_Status")
        aCoder.encode(self.typeUser.rawValue, forKey: "TypeUser")
    }
    
    //MARK: SET
    func setMobilePhone(_ data: String) {
        self.mobile_Phone = data
    }
    
    func setName(_ data: String) {
        self.fullName = data
    }
    
    func setGender(_ data: Gender) {
        self.gender = data
    }
    
    //MARK: GET
    func isFillAllData() -> Bool {
        if self.fullName == "" || self.mobile_Phone == "" {
            return false
        }
        return true
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let user = object as? User else { return false }
        
        if user.fullName == self.fullName && self.mobile_Phone == self.mobile_Phone && self.gender.rawValue == user.gender.rawValue {
            return true
        }
        
        return false
    }
    
}

//MARK: - NSCopying
extension User: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        return User.init(from: self)
    }
    
}

//MARK: - TransfromData
extension User: TransfromData {
    
    func transformDictionaty() -> [String : Any] {
        return [ "UserID": self.userID,
                 "UserName": self.userName,
                 "Password": self.password,
                 "FullName": self.fullName,
                 "Gender": self.gender.rawValue,
                 "MedicalCenterID": self.medicalCenterID,
                 "DepartmentId": self.departmentId,
                 "Mobile_Phone": self.mobile_Phone,
                 "Doctor_Degree": self.doctor_Degree,
                 "RankId": self.rankId,
                 "Status": self.status,
                 "DoctorAssistant_Enable": self.doctorAssistant_Enable,
                 "Access_LastTime": self.access_LastTime,
                 "Acc_Status": self.acc_Status
        ]
    }
    
}

