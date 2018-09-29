//
//  PrescriptionHelper.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 3/13/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class PrescriptionHelper {
    
    
    static func normalize(_ prescriptions: [Prescription]) -> [Prescription] {
        var dicKey = [String: Int]()
        var returnValue = [Prescription]()
        
        for (index, prescription) in prescriptions.enumerated() {
            if !dicKey.contains(where: { (key, value) -> Bool in
                return key.lowercased() == prescription.prescriptionCode.lowercased()
            }) {
                dicKey[prescription.prescriptionCode] = index
            }
        }
        
        for (_, value) in dicKey {
            returnValue.append(prescriptions[value])
        }
        
        returnValue = returnValue.sorted(by: { (prescription1, prescription2) -> Bool in
            return prescription1.createDate > prescription2.createDate
        })
        
        return returnValue
    }
    
}



