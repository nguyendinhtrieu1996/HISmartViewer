//
//  PatientInfomationFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/28/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class PatientInfomationFacade {
    
    static func updatePatientBloodPressureWarning(patientID: String, systolic: BloodPressure, diastolic: BloodPressure, completionHandler: @escaping (Bool)->Void) {
        let parameter: [String: Any] = [
            "PID_ID": patientID,
            "LowSystolic": systolic.low,
            "PreHighSystolic" : systolic.preHigh,
            "HighSystolic" : systolic.high,
            "LowDiastolic" : diastolic.low,
            "PreHighDiastolic" : diastolic.preHigh,
            "HighDiastolic" : diastolic.high,
            ]
        
        NetworkClient.request(urlRequest: APIEndpoint.UpdatePatientBloodPressureWarning, method: .post, parameter: parameter) { (data) in
            if let result = String.init(data: data!, encoding: String.Encoding.utf8) {
                if result == "\"success\"" {
                    completionHandler(true)
                    return
                }
            }
            completionHandler(false)
        }
    }
    
    static func getAddressForCurrentPatient(completionHandler: @escaping ()->Void) {
        let dispathGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async {
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.address, method: .get, parameter: nil) { (data) in
                let listAddress: [Address] = ParserHelper.parseArrayObject(data)
                let addressID = HISMartManager.share.currentPatient.address_ID
                
                let address = listAddress.filter { (address) -> Bool in
                    return address.addressID == addressID
                    }.first
                
                HISMartManager.share.currentPatient.setAddress(address)
                dispathGroup.leave()
            }
            
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.ShareDoctorsByPatientID, method: .get, parameter: ["Id": HISMartManager.share.currentPatient.PID_ID]) { (data) in
                let users: [User] = ParserHelper.parseArrayObject(data)
                HISMartManager.share.currentPatient.setDoctorsFollow(users)
                dispathGroup.leave()
            }
            
            let _ = dispathGroup.wait(wallTimeout: .now() + 200)
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
}
