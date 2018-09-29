//
//  AddNewDrugFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class AddNewDrugFacade {
    
    static func postPrescription(prescription: Prescription, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        let parameters = prescription.transformDictionaty()
        
        NetworkClient.request(urlRequest: APIEndpoint.prescriptionsAPI, method: .post, parameter: parameters) { (data) in
            guard let data = data else {
                errorHandler()
                return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? String else {
                errorHandler()
                return
            }
            
            if result == StatusRequest.success.rawValue {
                completionHandler()
            } else {
                errorHandler()
            }
        }
    }
    
}
