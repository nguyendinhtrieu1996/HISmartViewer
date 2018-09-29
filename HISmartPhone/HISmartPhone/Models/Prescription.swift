//
//  Drug.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/16/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class Prescription: Mapper, Hashable {
    var hashValue: Int = 0
    
    static func ==(lhs: Prescription, rhs: Prescription) -> Bool {
        if lhs.prescriptionCode == rhs.prescriptionCode {
            return true
        }
        
        return false
    }
    
    private (set) var id: Int
    private (set) var PID_ID: String
    private (set) var dateApply: String
    private (set) var prescriptionCode: String
    private (set) var prescriptionName: String
    private (set) var prescriptionQuantity: Int
    private (set) var comment: String
    private (set) var evaluation: String
    private (set) var createDate: Date
    private (set) var lastUpdate: Date
    private (set) var doctorID: String
    private (set) var status: Int
    private (set) var remove: Int
    
    private (set) var doctor: User
    private (set) var patient: User
    
    init() {
        self.id = -1
        self.PID_ID = HISMartManager.share.currentPID_ID
        self.dateApply = ""
        self.prescriptionCode = ""
        self.prescriptionName = ""
        self.prescriptionQuantity = 0
        self.comment = ""
        self.evaluation = ""
        self.createDate = Date()
        self.lastUpdate = Date()
        self.doctorID = HISMartManager.share.currentDoctorID
        self.status = 0
        self.remove = 0
        doctor = User()
        patient = User()
    }
    
    required init(_ data: [String : Any]) {
        self.id = data["Id"] as? Int ?? 0
        self.PID_ID = data["PID_ID"] as? String ?? ""
        self.dateApply = (data["DateApply"] as? String ?? "")
        self.prescriptionCode = data["PrescriptionCode"] as? String ?? ""
        self.prescriptionName = data["PrescriptionName"] as? String ?? ""
        self.prescriptionQuantity = data["PrescriptionQuantity"] as? Int ?? 0
        self.comment = data["Comment"] as? String ?? ""
        self.evaluation = data["Evaluation"] as? String ?? ""
        self.createDate = (data["CreateDate"] as? String ?? "").getDate()
        self.lastUpdate = (data["LastUpdate"] as? String ?? "").getDate()
        self.doctorID = data["DoctorID"] as? String ?? ""
        self.status = data["Status"] as? Int ?? 0
        self.remove = data["Remove"] as? Int ?? 0
        doctor = User()
        patient = User()
    }
    
    init(from data: Prescription) {
            self.id = data.id
            self.PID_ID = data.PID_ID
            self.dateApply = data.dateApply
            self.prescriptionCode = data.prescriptionCode
            self.prescriptionName = data.prescriptionName
            self.prescriptionQuantity = data.prescriptionQuantity
            self.comment = data.comment
            self.evaluation = data.evaluation
            self.createDate = data.createDate
            self.lastUpdate = data.lastUpdate
            self.doctorID = data.doctorID
            self.status = data.status
            self.remove = data.remove
            doctor = data.doctor
            patient = data.patient
    }
    
    //MARK:GET
    func isFillAllData() -> Bool {
        if self.prescriptionName == "" || self.prescriptionQuantity == 0 || self.dateApply == "" || self.comment == "" {
            return false
        }
        
        return true
    }
    
    func equal(with prescription: Prescription) -> Bool {
        if self.prescriptionName != prescription.prescriptionName || self.prescriptionQuantity != prescription.prescriptionQuantity || self.dateApply != prescription.dateApply || self.comment != prescription.comment {
            return false
        }
        return true
    }
    
    //MARK: SET
    func setCode(_ code: String) {
        self.prescriptionCode = code
    }
    
    func setDoctor(_ doctor: User) {
        self.doctor = doctor
    }
    
    func setPatient(_ patient: User) {
        self.patient = patient
    }
    
    func setName(_ name: String) {
        self.prescriptionName = name
    }
    
    func setDateApplye(_ dateApply: String) {
        self.dateApply = dateApply
    }
    
    func setQuanitty(_ quantity: Int) {
        self.prescriptionQuantity = quantity
    }
    
    func setComment(_ comment: String) {
        self.comment = comment
    }
    
    func setEvaluation(_ evaluation: String) {
        self.evaluation = evaluation
    }
    
    func setDoctorID(_ id: String) {
        self.doctorID = id
    }
    
}

//MARK: - NSCopying
extension Prescription: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Prescription.init(from: self)
    }
}

//MARK: - TransfromData
extension Prescription: TransfromData {
    
    func transformDictionaty() -> [String : Any] {
        return [
            "Id": self.id == -1 ? Constant.autoID : self.id,
            "PID_ID": self.PID_ID,
            "DateApply": self.dateApply,
            "PrescriptionCode": self.prescriptionCode,
            "PrescriptionName": self.prescriptionName,
            "PrescriptionQuantity": self.prescriptionQuantity,
            "Comment": self.comment,
            "Evaluation": self.evaluation,
            "CreateDate": self.createDate.getDescription_DDMMYYYY(),
            "LastUpdate": self.lastUpdate.getDescription_DDMMYYYY(),
            "DoctorID": self.doctorID,
            "Status": self.status,
            "Remove": self.remove
        ]
    }
    
}








