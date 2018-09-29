//
//  SharePatientFirebaseAPI.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/27/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SharePatientFirebaseAPI {

    static func POST_Patient(_ toDoctorID: String, doctorShareName: String, patient: Patient) {
        let ref = FirebaseReference.sharePatient_REF.child(toDoctorID).childByAutoId()
        let patientBeShared = PatientBeShared(id: ref.key, doctorName: doctorShareName, patient: patient)
        ref.setValue(patientBeShared.transformDictionary())
    }
    
    static func GET_BeSharedPatient(completionHandler: @escaping (DataSnapshot)-> Void) {
        FirebaseReference.sharePatient_REF.child(HISMartManager.share.currentDoctorID).observe(DataEventType.childAdded) { (dataSnapshot) in
            completionHandler(dataSnapshot)
        }
    }
    
    static func REMOVE_BeSharedPatient(_ nodeID: String) {
        FirebaseReference.sharePatient_REF.child(HISMartManager.share.currentDoctorID).child(nodeID).removeValue()
    }
}
