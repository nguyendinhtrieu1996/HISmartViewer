//
//  PrescriptionFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/16/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class PrescriptionFacade {
    
    private (set) var prescriptions: [Prescription]
    
    init() {
        self.prescriptions = []
    }
    
    
    func loadAllPrescription(completionHandler: @escaping ()->Void) {
        let dispathGroup = DispatchGroup()
        let paremater = ["Id": HISMartManager.share.currentPID_ID]
        
        NetworkClient.request(urlRequest: APIEndpoint.prescriptionsAPI, method: .get, parameter: paremater) { (data) in
            self.prescriptions = ParserHelper.parseArrayObject(data)
            self.prescriptions = PrescriptionHelper.normalize(self.prescriptions)
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                for (index, prescription) in self.prescriptions.enumerated() {
                    dispathGroup.enter()
                    
                    self.fetchUser(by: prescription.doctorID, completionHandler: { (doctor) in
                        self.prescriptions[index].setDoctor(doctor)
                        dispathGroup.leave()
                    })
                    
                    dispathGroup.enter()
                
                    self.fetchUser(by: prescription.PID_ID, completionHandler: { (patient) in
                        self.prescriptions[index].setPatient(patient)
                        dispathGroup.leave()
                    })
                    
                }
                
                let _ = dispathGroup.wait(timeout: .now() + 1000)
                
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
    }
    
    func fetchUser(by Id: String, completionHandler: @escaping (User)->Void) {
        let parameter = ["id": Id]
        NetworkClient.request(urlRequest: APIEndpoint.fetchUserByID, method: .get, parameter: parameter) { (data) in
            let user: User = ParserHelper.parseArrayObject(data).first ?? User()
            completionHandler(user)
        }
    }
    
    func deletePrescription(at indexPaths: [IndexPath], completionHandler: @escaping ()->Void) {
        let arrayIndex = indexPaths.map { (indexPath) -> Int in
            return indexPath.item
        }
        
        let dispathGroup = DispatchGroup()
        let deletePrescriptions = self.prescriptions.enumerated().filter { (index, diagnose) -> Bool in
            return arrayIndex.contains(index)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for (_, prescription) in deletePrescriptions {
                dispathGroup.enter()
                
                let parameter: [String: Any] = ["PID_ID": HISMartManager.share.currentPID_ID, "PrescriptionCode": prescription.prescriptionCode]
                NetworkClient.request(urlRequest: APIEndpoint.prescriptionsAPI, method: .delete, parameter: parameter, completion: { (data) in
                    dispathGroup.leave()
                })
            }
            
            let _ = dispathGroup.wait(timeout: .now() + 1000)
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
}
