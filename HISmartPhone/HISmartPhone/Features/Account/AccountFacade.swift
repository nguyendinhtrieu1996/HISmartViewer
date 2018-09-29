//
//  AccountFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/26/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class AccountFacade {
    
    static func fetchPatient(_ PID_ID: String, completionHandler: @escaping (Patient)->Void) {
        
        var patient = Patient()
        var mainDoctor: MainDoctor?
        var listAddress = [Address]()
        var listFollowDoctor = [User]()
        let dispathGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async {
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.infoPatient, method: .get, parameter: ["id": PID_ID]) { (data) in
                patient = ParserHelper.parseArrayObject(data).first ?? Patient()
                dispathGroup.leave()
            }
            
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.address, method: .get, parameter: nil) { (data) in
                listAddress = ParserHelper.parseArrayObject(data)
                dispathGroup.leave()
            }
            
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.ShareDoctorsByPatientID, method: .get, parameter: ["Id": PID_ID]) { (data) in
                listFollowDoctor = ParserHelper.parseArrayObject(data)
                dispathGroup.leave()
            }
            
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.getUserByPatient, method: .get, parameter: ["id": PID_ID], completion: { (data) in
                mainDoctor = ParserHelper.parseArrayObject(data).first
                dispathGroup.leave()
            })
            
            let _ = dispathGroup.wait(timeout: .now() + 200)
            
            let address = listAddress.filter { (address) -> Bool in
                return address.addressID == patient.address_ID
                }.first
            
            patient.setAddress(address)
            patient.setMainDoctor(mainDoctor)
            patient.setDoctorsFollow(listFollowDoctor)
            
            DispatchQueue.main.async {
                completionHandler(patient)
            }
        }
    }
    
    static func fetchListFollowDoctor(completionHanlder: @escaping ()->Void, errorHandler: ()->Void) {
        if Authentication.share.typeUser == .patient {
            errorHandler()
            return
        }
    }
    
}










