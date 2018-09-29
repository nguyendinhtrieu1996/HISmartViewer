//
//  StatisticalAnalysisFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class StatisticalAnalysisFacade {
    
    static func getStaticsticalFromToDate(fromDate: Date, toDate: Date, completionHander: @escaping ([BPOResult])->Void) {
        let parameters = ["PID_ID": HISMartManager.share.currentPID_ID,
                          "fromDate": fromDate.getDesciption(),
                          "toDate": toDate.getDesciption()]
        
        NetworkClient.request(urlRequest: APIEndpoint.GETBPOPatientByDate, method: .get, parameter: parameters) { (data) in
            let BPOResults: [BPOResult] = ParserHelper.parseArrayObject(data)
            BPOHelper.shared.setBPOPatients(BPOResults)
            completionHander(BPOResults)
        }
        
    }
    
}
