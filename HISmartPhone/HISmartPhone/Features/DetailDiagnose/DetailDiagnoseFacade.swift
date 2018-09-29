//
//  DetailDiagnoseFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/18/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class DetailDiagnoseFacade {
    
    static func deleteDiagnose(by idDiagnose: Int, completionHandler: @escaping ()->Void) {
        let parameter = ["Id": idDiagnose]
        
        NetworkClient.request(urlRequest: APIEndpoint.diagnoseAPI, method: .delete, parameter: parameter, completion: { (data) in
            completionHandler()
        })
        
    }
}
