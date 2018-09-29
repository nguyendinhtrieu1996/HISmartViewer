//
//  Diagnose.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/17/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class Diagnose: Mapper {
    
    private (set) var id: Int
    private (set) var PID_ID: String
    private (set) var mainSick: String
    private (set) var diagnose: String
    private (set) var solution: String
    private (set) var solve: String
    private (set) var createDate: Date
    private (set) var lastUpdate: Date
    private (set) var doctorID: String
    private (set) var advice: String
    private (set) var status: Int
    private (set) var remove: Int
    
    private (set) var doctor: User
    private (set) var patient: User
    
    init() {
        id = -1
        PID_ID = HISMartManager.share.currentPID_ID
        mainSick = ""
        diagnose = ""
        solution = ""
        solve = ""
        createDate = Date()
        lastUpdate = Date()
        doctorID = Authentication.share.currentUserId
        advice = ""
        status = 0
        remove = 0
        doctor = User()
        patient = User()
    }
    
    required init(_ data: [String : Any]) {
        id = data["Id"] as? Int ?? -1
        PID_ID = data["PID_ID"] as? String ?? ""
        mainSick = data["MainSick"] as? String ?? ""
        diagnose = data["Diagnose"] as? String ?? ""
        solution = data["Solution"] as? String ?? ""
        solve = data["Solve"] as? String ?? ""
        createDate = (data["CreateDate"] as? String ?? "").getDate()
        lastUpdate = (data["LastUpdate"] as? String ?? "").getDate()
        doctorID = data["DoctorID"] as? String ?? ""
        advice = data["Advice"] as? String ?? ""
        status = data["Status"] as? Int ?? 0
        remove = data["Remove"] as? Int ?? 0
        doctor = User()
        patient = User()
    }
    
    init(from data: Diagnose) {
        id = data.id
        PID_ID = data.PID_ID
        mainSick = data.mainSick
        diagnose = data.diagnose
        solution = data.solution
        solve = data.solve
        createDate = data.createDate
        lastUpdate = data.lastUpdate
        doctorID = data.doctorID
        advice = data.advice
        status = data.status
        remove = data.remove
        doctor = data.doctor
        patient = data.patient
    }
    
    //MARK: SET
    func setDoctor(_ doctor: User) {
        self.doctor = doctor
    }
    
    func setPatient(_ patient: User) {
        self.patient = patient
    }
    
    func setMainSick(_ value: String) {
        self.mainSick = value
    }
    
    func setDiagnose(_ value: String) {
        self.diagnose = value
    }
    
    func setSolution(_ value: String) {
        self.solution = value
    }
    
    func setSolve(_ value: String) {
        self.solve = value
    }
    
    func setAdvice(_ value: String) {
        self.advice = value
    }
    
    //MARK: GET
    func isFillAllData() -> Bool {
        if self.mainSick == "" || self.diagnose == "" || self.solution == "" || self.solve == "" || self.advice == "" {
            return false
        }
        return true
    }
    
    func equal(with data: Diagnose) -> Bool {
        if data.id != id || data.mainSick != mainSick || data.diagnose != diagnose || data.solution != solution || data.solve != solve || data.advice != advice {
            return false
        }
        return true
    }
    
}

//MARK: - NSCopying
extension Diagnose: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let diagnose = Diagnose.init(from: self)
        return diagnose
    }
}

//MARK: - TransfromData
extension Diagnose: TransfromData {
    
    func transformDictionaty() -> [String : Any] {
        self.doctorID = Authentication.share.currentUserId
        
        return [ "Id": self.id == -1 ? Constant.autoID : self.id,
                 "PID_ID": self.PID_ID,
                 "MainSick": self.mainSick,
                 "Diagnose": self.diagnose,
                 "Solution": self.solution,
                 "Solve": self.solve,
                 "CreateDate": self.createDate.getDesciption(),
                 "LastUpdate": self.lastUpdate.getDesciption(),
                 "DoctorID": self.doctorID,
                 "Advice": self.advice,
                 "Status": self.status,
                 "Remove": self.remove
        ]
    }

}



