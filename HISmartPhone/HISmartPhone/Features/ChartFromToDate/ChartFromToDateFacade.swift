//
//  ChartFromToDateFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class ChartFromToDateFacade {
    
    static func fetchBPOResults(_ date: Date, _ patientID: String, completionHanlder: @escaping ([BPOResult])->Void) {
        let fromDate = Date.getDayBeforeOrAfter(date, -Constant.dayLoadChart)
        let toDate = Date.getDayBeforeOrAfter(date, Constant.dayLoadChart)
        var BPOResults = [BPOResult]()
        
        let parameter = ["PID_ID": patientID,
                         "fromDate": fromDate.getDesciption(),
                         "toDate": toDate.getDesciption()]
        
        NetworkClient.request(urlRequest: APIEndpoint.GETBPOPatientByDate, method: .get, parameter: parameter) { (data) in
            BPOResults = ParserHelper.parseArrayObject(data)
            
            BPOResults.sort(by: { (result1, result2) -> Bool in
                return result1.observation_Date < result2.observation_Date
            })
            
            completionHanlder(BPOResults)
        }
        
    }
    
}















