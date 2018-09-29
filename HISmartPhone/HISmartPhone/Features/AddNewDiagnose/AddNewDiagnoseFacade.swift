//
//  AddNewDiagnoseFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/17/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class AddNewDiagnoseFacade {
    
    static func updateNewValue(diagnose: Diagnose, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        let parameter = diagnose.transformDictionaty()
        
        NetworkClient.request(urlRequest: APIEndpoint.diagnoseAPI, method: .post, parameter: parameter) { (data) in
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










