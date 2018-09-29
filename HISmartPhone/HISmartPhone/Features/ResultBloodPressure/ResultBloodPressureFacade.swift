//
//  ResultBloodPressureFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class ResultBloodPressureFacade {
    
    static func fetchAllBloodPressures(completionHandler: @escaping ()->Void) {
        let dispathGroup = DispatchGroup()
        let parameter = ["Id": HISMartManager.share.currentPID_ID]
        
        DispatchQueue.global(qos: .userInteractive).async {
            dispathGroup.enter()
            
            NetworkClient.request(urlRequest: APIEndpoint.bloodPressureAPI, method: .get, parameter: parameter) { (data) in
                var BPOResults: [BPOResult] = ParserHelper.parseArrayObject(data)
                
                BPOResults.sort(by: { (result1, result2) -> Bool in
                    return result1.observation_Date > result2.observation_Date
                })
                
                BPOChartManager.shared.setAllBPOResults(BPOResults)
                dispathGroup.leave()
            }
            
            if HISMartManager.share.currentPatient.BPOPatient == nil {
                dispathGroup.enter()
                NetworkClient.request(urlRequest: APIEndpoint.bloodPressureContantAPI, method: .get, parameter: parameter) { (data) in
                    
                    guard let BPOPatient: BPOPatient = ParserHelper.parseArrayObject(data).first else {
                        return
                    }
                    
                    HISMartManager.share.currentPatient.setBPOPatient(BPOPatient)
                    dispathGroup.leave()
                }
            }
            
            
            let _ = dispathGroup.wait(timeout: .now() + 200)
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    static func deleteBPOResult(at indexPaths: [IndexPath], completionHandler: @escaping ()->Void) {
        let arrayIndex = indexPaths.map { (indexPath) -> Int in
            return indexPath.item
        }
        
        let dispathGroup = DispatchGroup()
        let deleteBPOResults = BPOChartManager.shared.BPOResults.enumerated().filter { (index, diagnose) -> Bool in
            return arrayIndex.contains(index)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            for (_, BPOResult) in deleteBPOResults {
                dispathGroup.enter()
                
                let parameter = ["Id": BPOResult.BPOBR_ID]
                NetworkClient.request(urlRequest: APIEndpoint.bloodPressureAPI, method: .delete, parameter: parameter, completion: { (data) in
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
