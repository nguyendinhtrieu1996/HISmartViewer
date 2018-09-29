//
//  SharePatientFacade.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/25/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class SharePatientFacade {
    
    private (set) var sharedPatients: [SharePatientByDoctor] = []
    private (set) var beSharedPatients: [SharePatientByDoctor] = []
    
    func fetchListOfSharedPatient(completionHandler: @escaping ([SharePatientByDoctor]) -> Void) {
        let parameter = ["id": HISMartManager.share.currentDoctorID]
        let dispathgroup = DispatchGroup()
        
        NetworkClient.request(urlRequest: APIEndpoint.FetchPatientSharedByDoctorID, method: .get, parameter: parameter) { (data) in
            self.sharedPatients = ParserHelper.parseArrayObject(data)
            
            DispatchQueue.global(qos: .userInteractive).async {
                for (index, patient) in self.sharedPatients.enumerated() {
                    dispathgroup.enter()
                    self.fetchPatient(by: patient.patientID, completion: { (patient) in
                        self.sharedPatients[index].setPatientInfo(patient)
                        dispathgroup.leave()
                    }, errorHandler: {
                        dispathgroup.leave()
                    })
                }
                
                let _ = dispathgroup.wait(timeout: .now() + 100000)
                DispatchQueue.main.async {
                    completionHandler(self.sharedPatients)
                }
            }
        }
    }
    
    func fetchListOfBeSharePatient(completionHandler: @escaping ([SharePatientByDoctor]) -> Void) {
        let parameter = ["id": HISMartManager.share.currentDoctorID]
        let dispathgroup = DispatchGroup()
        
        NetworkClient.request(urlRequest: APIEndpoint.FetchPatientBeSharedByDoctorID, method: .get, parameter: parameter) { (data) in
            self.beSharedPatients = ParserHelper.parseArrayObject(data)
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                for (index, patient) in self.beSharedPatients.enumerated() {
                    dispathgroup.enter()
                    
                    self.fetchPatient(by: patient.patientID, completion: { (patient) in
                        self.beSharedPatients[index].setPatientInfo(patient)
                        dispathgroup.leave()
                    }, errorHandler: {
                        dispathgroup.leave()
                    })
                }
                
                let _ = dispathgroup.wait(timeout: .now() + 100000)
                DispatchQueue.main.async {
                    completionHandler(self.beSharedPatients)
                }
            }
        }
    }
    
    func fetchPatient(by id: String, completion: @escaping (Patient)->Void, errorHandler: @escaping ()->Void) {
        let params = ["id": id]
        NetworkClient.request(urlRequest: APIEndpoint.patientRegister, method: .get, parameter: params) { (data) in
            guard let patient: Patient = ParserHelper.parseArrayObject(data).first else {
                errorHandler()
                return
            }
            
            completion(patient)
        }
    }
    
    func removeSharePatientToDoctor(_ patientID: String, toDoctorID: [String], completion: @escaping (Bool) -> Void) {
        let dispathGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .utility).async {
            for doctorID in toDoctorID {
                dispathGroup.enter()
                let parameter = [
                    "PID_ID": patientID,
                    "sUserID": doctorID
                ]
                NetworkClient.request(urlRequest: APIEndpoint.RemovePatientShareToDoctorID, method: .delete, parameter: parameter) { (data) in
                    if let result = String.init(data: data!, encoding: String.Encoding.utf8) {
                        if result == "\"success\"" {
                            print("Unshare Success doctor ID \(doctorID)")
                        } else {
                            print("Unshare Fail doctor ID \(doctorID)")
                        }
                    }
                    dispathGroup.leave()
                }
            }
            let status = dispathGroup.wait(wallTimeout: .now() + 200)
            
            if status == DispatchTimeoutResult.success {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
