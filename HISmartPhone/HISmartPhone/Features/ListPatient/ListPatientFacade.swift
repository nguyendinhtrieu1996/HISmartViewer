//
//  ListPatientFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/11/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class ListPatientFacade {
    
    static func loadAllPatient(completionHandler: @escaping ([Patient])->Void) {
        let parameter = ["Id": Authentication.share.currentUserId]
        NetworkClient.request(urlRequest: APIEndpoint.fetchPatientByDoctor, method: .get, parameter: parameter) { (data) in
            let listPatient: [Patient] = ParserHelper.parseArrayObject(data)
            completionHandler(listPatient)
        }
    }
    
}
