//
//  PatientBeShared.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/28/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class PatientBeShared: Mapper {
    
    private (set) var id: String
    private (set) var doctorName: String
    private (set) var patient: Patient
    
    init(id: String, doctorName: String, patient: Patient) {
        self.id = id
        self.doctorName = doctorName
        self.patient = patient
    }
    
    required init(_ data: [String : Any]) {
        self.id = data["ID"] as? String ?? ""
        self.doctorName = data["Doctor_Name"] as? String ?? ""
        guard let dic = data["Patient"] as? [String: Any] else {
            self.patient = Patient()
            return
        }
        self.patient = Patient(dic)
    }
    
    func transformDictionary() -> [String: Any] {
        return [
            "ID": self.id,
            "Doctor_Name": self.doctorName,
            "Patient": self.patient.transformDictionaty()
        ]
    }
}
