//
//  BPOResult.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/19/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class BPOResult: Mapper {
    private (set) var BPOBR_ID: Int
    private (set) var PID_ID: String
    private (set) var observation_Date: Date
    private (set) var SYST: Int
    private (set) var DIAS: Int
    private (set) var PULS: Int
    private (set) var remove: Int
    
    private (set) var isNormalize = false
    
    init() {
        BPOBR_ID = 0
        PID_ID = ""
        observation_Date = Date()
        SYST = 1
        DIAS = 1
        PULS = 1
        remove = 0
    }
    
    required init(_ data: [String : Any]) {
        BPOBR_ID = data["BPOBR_ID"] as? Int ?? 0
        PID_ID = data["PID_ID"] as? String ?? ""
        observation_Date = (data["Observation_Date"] as? String ?? "").getDate()
        SYST = data["SYST"] as? Int ?? 1
        DIAS = data["DIAS"] as? Int ?? 1
        PULS = data["PULS"] as? Int ?? 0
        remove = data["Remove"] as? Int ?? 0
    }
    
    func normalize() {
        if self.DIAS == 0 {
            self.DIAS = 1
            self.isNormalize = true
        }
    }
    
    func unNormalize() {
        self.isNormalize = false
        self.DIAS = 0
    }
    
}




