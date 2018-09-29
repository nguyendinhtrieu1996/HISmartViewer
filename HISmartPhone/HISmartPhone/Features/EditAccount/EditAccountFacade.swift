//
//  EditAccountFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/28/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class EditAccountFacade {
    
    static func UPDATE_User(_ user: User, completionHanlder: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        NetworkClient.request(urlRequest: APIEndpoint.patientRegister, method: .post, parameter: user.transformDictionaty()) { (data) in
            guard let data = data else {
                errorHandler()
                return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? String else {
                errorHandler()
                return
            }
            
            if result == StatusRequest.success.rawValue {
                completionHanlder()
            } else {
                errorHandler()
            }
        }
    }
    
    static func UPDATE_Patient(_ patient: Patient, completionHanlder: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        
        print(patient.transformDictionatyRegister())
        
        NetworkClient.request(urlRequest: APIEndpoint.patientRegister, method: .post, parameter: patient.transformDictionatyRegister()) { (data) in
            guard let data = data else {
                errorHandler()
                return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? String else {
                errorHandler()
                return
            }
            
            if result == StatusRequest.success.rawValue {
                completionHanlder()
            } else {
                errorHandler()
            }
        }
    }
    
    static func GET_AllAddress(completionHadler: @escaping ([Address])->Void) {
        NetworkClient.request(urlRequest: APIEndpoint.address, method: .get, parameter: nil) { (data) in
            let listAddress: [Address] = ParserHelper.parseArrayObject(data)
            completionHadler(listAddress)
        }
    }
    
}
