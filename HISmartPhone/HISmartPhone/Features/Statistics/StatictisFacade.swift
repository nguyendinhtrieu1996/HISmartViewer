//
//  StatictisFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/25/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class StatictisFacade {
    
    static func fetchBloodPressures(_ fromDate: Date, _ toDate: Date, completionHandler: @escaping (BPOFromToDateManager)->Void) {
        
        let BPOFromToDate = BPOFromToDateManager()
        let dispathGroup = DispatchGroup()
        let parameter = ["PID_ID": HISMartManager.share.currentPID_ID,
                         "fromDate": fromDate.getDesciption(),
                         "toDate": toDate.getDesciption()]
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            dispathGroup.enter()
            
            NetworkClient.request(urlRequest: APIEndpoint.GETBPOPatientByDate, method: .get, parameter: parameter) { (data) in
                var BPOResults: [BPOResult] = ParserHelper.parseArrayObject(data)
                
                BPOResults.sort(by: { (result1, result2) -> Bool in
                    return result1.observation_Date > result2.observation_Date
                })
                
                BPOFromToDate.setBPOResults(BPOResults)
                dispathGroup.leave()
            }
            
            
            if HISMartManager.share.currentPatient.BPOPatient == nil {
                dispathGroup.enter()
                NetworkClient.request(urlRequest: APIEndpoint.bloodPressureContantAPI, method: .get, parameter: ["Id": HISMartManager.share.currentPID_ID]) { (data) in
                    
                    guard let BPOPatient: BPOPatient = ParserHelper.parseArrayObject(data).first else {
                        return
                    }
                    
                    HISMartManager.share.currentPatient.setBPOPatient(BPOPatient)
                    dispathGroup.leave()
                }
            }
            
            let _ = dispathGroup.wait(timeout: .now() + 200)
            
            DispatchQueue.main.async {
                completionHandler(BPOFromToDate)
            }
        }
    }
    
}
