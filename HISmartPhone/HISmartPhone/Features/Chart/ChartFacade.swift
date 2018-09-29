//
//  ChartFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class ChartFacade {
    
    static func fetchAllBPOResults(completionHanlder: @escaping ([BPOResult])->Void, noneReultsCompletionHandler: ()->Void) {
        let dispathGroup = DispatchGroup()
        var BPOResults = [BPOResult]()
        
        let parameter = ["Id": HISMartManager.share.currentPID_ID]
        
        DispatchQueue.global(qos: .userInteractive).async {
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.bloodPressureAPI, method: .get, parameter: parameter) { (data) in
                BPOResults = ParserHelper.parseArrayObject(data)
                
                BPOResults.sort(by: { (result1, result2) -> Bool in
                    return result1.observation_Date < result2.observation_Date
                })
                
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
                completionHanlder(BPOResults)
            }
        }
        
    }
    
}
