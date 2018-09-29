//
//  BPOChartManager.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/24/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class BPOChartManager {

    class var shared: BPOChartManager {
        struct Static {
            static var instance = BPOChartManager()
        }

        return Static.instance
    }

    private init() {

    }

    var BPOResults: [BPOResult] = []

    //MARK: SET
    func setAllBPOResults(_ BPOResults: [BPOResult]) {
        self.BPOResults = BPOResults
    }

    //MARK: PIE
    var allDataForPIEChart: [Int] {
        var valuesBPO = [Int]()

        valuesBPO.append(numberLowBPO)
        valuesBPO.append(numberNormalBPO)
        valuesBPO.append(numberHighBPO)
        valuesBPO.append(numberVeryHighBPO)

        return valuesBPO
    }

    var numberNormalBPO: Int {
        return self.BPOResults.count - self.numberLowBPO - self.numberHighBPO - self.numberVeryHighBPO
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

    //MARK : GET
    func getAllMonth() -> [String] {
        var result = [String]()

        result += self.BPOResults.map({ (BPOResult) -> String in
            return BPOResult.observation_Date.getDescptionDateChart()
        })

        return result
    }

    func getAllSYS() -> [Double] {
        var result = [Double]()

        result += self.BPOResults.map({ (BPOResult) -> Double in
            return Double(BPOResult.SYST)
        })

        return result
    }

    func getAllDIAS() -> [Double] {
        var result = [Double]()

        result += self.BPOResults.map({ (BPOResult) -> Double in
            return Double(BPOResult.DIAS)
        })

        return result
    }

    func getAllHeartRate() -> [Double] {
        var result = [Double]()

        result += self.BPOResults.map({ (BPOResult) -> Double in
            return Double(BPOResult.PULS)
        })

        return result
    }

}
