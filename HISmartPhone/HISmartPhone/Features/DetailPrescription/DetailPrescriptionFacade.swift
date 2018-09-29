//
//  DetailPrescriptionFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class DetailPrescriptionFacade {
    
    static func deletePrescription(by idPrescription: Int, completionHandler: @escaping ()->Void) {
        let parameter = ["Id": idPrescription]
        
        NetworkClient.request(urlRequest: APIEndpoint.prescriptionsAPI, method: .delete, parameter: parameter, completion: { (data) in
            completionHandler()
        })
        
    }
    
    static func fetchAllDrug(of prescriptionCode: String, completionHanlder: @escaping ([Prescription])->Void) {
        let parameter = ["id": prescriptionCode,
                         "pid_id": HISMartManager.share.currentPID_ID]
        
        NetworkClient.request(urlRequest: APIEndpoint.getDrugOfPrescription, method: .get, parameter: parameter) { (data) in
            var listPrescription: [Prescription] = ParserHelper.parseArrayObject(data)
            listPrescription = listPrescription.sorted(by: { $0.createDate > $1.createDate })
            completionHanlder(listPrescription)
        }
    }
    
}
