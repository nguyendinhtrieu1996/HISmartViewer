//
//  DiagnoseFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/17/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class DiagnoseFacade {
    
    private (set) var diagnoses: [Diagnose]
    
    init() {
        self.diagnoses = []
    }
    
    func fetchDiagnoseOfPatient(completionHandler: @escaping ()->Void) {
        self.diagnoses.removeAll()
        let paramter = ["id": HISMartManager.share.currentPID_ID]
        let dispathGroup = DispatchGroup()
        
        NetworkClient.request(urlRequest: APIEndpoint.diagnoseAPI, method: .get, parameter: paramter) { (data) in
            self.diagnoses = ParserHelper.parseArrayObject(data)
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                for (index, diagnose) in self.diagnoses.enumerated() {
                    dispathGroup.enter()
                    
                    self.fetchUser(by: diagnose.doctorID, completionHandler: { (doctor) in
                        self.diagnoses[index].setDoctor(doctor)
                        dispathGroup.leave()
                    })
                    
                    dispathGroup.enter()
                    
                    self.fetchUser(by: diagnose.PID_ID, completionHandler: { (patient) in
                        self.diagnoses[index].setPatient(patient)
                        dispathGroup.leave()
                    })
                    
                }
                
                let _ = dispathGroup.wait(timeout: .now() + 1000)
                
                DispatchQueue.main.async {
                    self.diagnoses.sort(by: { (diagnose1, diagnose2) -> Bool in
                        return diagnose1.id > diagnose2.id
                    })
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
    
    func deleteDiagnose(at indexPaths: [IndexPath], completionHandler: @escaping ()->Void) {
        let arrayIndex = indexPaths.map { (indexPath) -> Int in
            return indexPath.item
        }
        
        let dispathGroup = DispatchGroup()
        let deleteDiagnoses = self.diagnoses.enumerated().filter { (index, diagnose) -> Bool in
            return arrayIndex.contains(index)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for (_, diagnose) in deleteDiagnoses {
                dispathGroup.enter()
                
                let parameter = ["Id": diagnose.id]
                NetworkClient.request(urlRequest: APIEndpoint.diagnoseAPI, method: .delete, parameter: parameter, completion: { (data) in
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










