//
//  BPOHelper.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/23/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class BPOHelper {
    
    class var shared: BPOHelper {
        struct Static {
            static var instance = BPOHelper()
        }
        
        return Static.instance
    }
    
    var BPOResults: [BPOResult] = []
    
    //MARK: APPRECIATE BPO
    var averageBPO: String {
        get {
            if BPOResults.isEmpty { return "" }
            
            let SYS = self.BPOResults.reduce(0, { (result, BPOResult) -> Int in
                return BPOResult.SYST + result
            }) / (self.BPOResults.count)
            
            let DIA = self.BPOResults.reduce(0, { (result, BPOResult) -> Int in
                return BPOResult.DIAS + result
            }) / (self.BPOResults.count)
            
            return "\(SYS) / \(DIA)"
        }
    }
    
    var minimumValue: String {
        get {
            guard var minBPO = BPOResults.first else { return "0 / 0"}
            var DIAS: Int

            for item in self.BPOResults {
                DIAS = item.DIAS == 0 ? 1 : item.DIAS
                minBPO.normalize()
                
                if (minBPO.SYST / minBPO.DIAS) > (item.SYST / DIAS) {
                    minBPO = item
                }
            }
            
            if minBPO.isNormalize {
                minBPO.unNormalize()
            }
            
            return "\(minBPO.SYST) / \(minBPO.DIAS)"
        }
    }
    var maximumValue: String {
        get {
            guard var maxBPO = BPOResults.first else { return "0 / 0" }
            var DIAS: Int
            
            for item in self.BPOResults {
                DIAS = item.DIAS == 0 ? 1 : item.DIAS
                maxBPO.normalize()
                
                if (maxBPO.SYST / maxBPO.DIAS) < (item.SYST / DIAS) {
                    maxBPO = item
                }
            }
            
            if maxBPO.isNormalize {
                maxBPO.unNormalize()
            }
            
            return "\(maxBPO.SYST) / \(maxBPO.DIAS)"
        }
    }
    
    var numberLowBPO: Int {
        get {
            guard let BPOPatient = HISMartManager.share.currentPatient.BPOPatient else { return 0 }
            
            return self.BPOResults.reduce(0) { (result, BPOResult) -> Int in
                if (BPOResult.SYST <= BPOPatient.lowSystolic) && (BPOResult.DIAS <= BPOPatient.lowDiastolic) {
                    return result + 1
                }
                return result
            }
        }
    }
    
    var numberHighBPO: Int {
        get {
            guard let BPOPatient = HISMartManager.share.currentPatient.BPOPatient else { return 0 }
            
            return self.BPOResults.reduce(0) { (result, BPOResult) -> Int in
                if (BPOResult.SYST >= BPOPatient.highSystolic) && (BPOResult.DIAS >= BPOPatient.highDiastolic) {
                    return result + 1
                }
                return result
            }
        }
    }
    
    var numberVeryHighBPO: Int {
        get {
            guard let BPOPatient = HISMartManager.share.currentPatient.BPOPatient else { return 0 }
            
            return self.BPOResults.reduce(0) { (result, BPOResult) -> Int in
                if (BPOResult.SYST >= BPOPatient.preHighSystolic) && (BPOResult.DIAS >= BPOPatient.preHighDiastolic) {
                    return result + 1
                }
                return result
            }
        }
    }
    
    var totalNumberHighBPO: Int {
        return self.numberHighBPO + self.numberVeryHighBPO
    }
    
    private init() {}
    
    //MARK: SET
    func setBPOPatients(_ BPOResults: [BPOResult]) {
        self.BPOResults = BPOResults
    }
    
    func destroy() {
        self.BPOResults.removeAll()
    }
    
}
