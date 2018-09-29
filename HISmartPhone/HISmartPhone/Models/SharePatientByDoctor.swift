//
//  SharePatientByDoctor.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/26/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class SharePatientByDoctor: Mapper {
    
    private (set) var userID: String
    private (set) var fullName: String
    private (set) var patientID: String
    private (set) var patientName: String
    private (set) var patientInfo: Patient
    
    init() {
        self.userID = ""
        self.fullName = ""
        self.patientID = ""
        self.patientName = ""
        self.patientInfo = Patient()
    }
    
    required init(_ data: [String : Any]) {
        self.userID = data["UserID"] as? String ?? ""
        self.fullName = data["FullName"] as? String ?? ""
        self.patientID = data["PID_ID"] as? String ?? ""
        self.patientName = data["Patient_Name"] as? String ?? ""
        self.patientInfo = Patient()
    }
    
    public func setPatientInfo(_ patient: Patient) {
        self.patientInfo = patient;
    }
    
}

class DoctorBeShared {
    private (set) var id: String
    private (set) var name: String
    var selected: Bool
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.selected = true
    }
}

class SharedPatient{
    private (set) var id: String
    private (set) var name: String
    private (set) var patientInfo: Patient
    private (set) var doctors: [DoctorBeShared]
    
    init(id: String, sharePatientByDoctors: [SharePatientByDoctor]) {
        self.id = id
        self.name = sharePatientByDoctors.first?.patientName ?? ""
        self.patientInfo = sharePatientByDoctors.first?.patientInfo ?? Patient()
        self.doctors = []
        for doc in sharePatientByDoctors {
            let doctor = DoctorBeShared(id: doc.userID, name: doc.fullName)
            self.doctors.append(doctor)
        }
    }
}










