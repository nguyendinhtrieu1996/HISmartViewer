//
//  BeSharedManager.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/27/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BeSharedManager {
    
    private var listPatientBeShared: [PatientBeShared] = []
    var isShow: Bool? {
        willSet {
            guard let value = newValue else { return }
            if !value {
                self.showNextPatient()
            }
        }
    }
    
    class var share: BeSharedManager {
        struct Static {
            static var instanse = BeSharedManager()
        }
        return Static.instanse
    }
    
    private init() {
        self.isShow = false
        self.observerbleBeSharedPatient()
    }
    
    private func observerbleBeSharedPatient() {
        SharePatientFirebaseAPI.GET_BeSharedPatient { (data) in
            guard let dic = data.value as? [String: Any] else { return }
            guard let isShow = self.isShow else { return }
            
            let patientBeShared = PatientBeShared(dic)
            
            if patientBeShared.id == "" { return }
            if isShow {
                self.listPatientBeShared.append(patientBeShared)
                LocalNotificationManager.share.PushNotificationLocal("Thông tin bệnh nhân được chia sẻ", subTitle: "Từ Bs.\(patientBeShared.doctorName)", body: "Bệnh nhân tên: \(patientBeShared.patient.patient_Name)", time: TimeInterval(self.listPatientBeShared.count))
                return
            }
            
            let popUp = ShareInfoPatientAlert()
            popUp.patientBeShared = patientBeShared
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                self.isShow = true
                topController.present(popUp, animated: true, completion: {
                    SharePatientFirebaseAPI.REMOVE_BeSharedPatient(patientBeShared.id)
                })
            }
        }
    }
    
    private func showNextPatient() {
        if self.listPatientBeShared.count <= 0 {
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let popUp = ShareInfoPatientAlert()
            let patientBeShared = self.listPatientBeShared.remove(at: 0)
            popUp.patientBeShared = patientBeShared
            self.isShow = true
            topController.present(popUp, animated: true, completion: {
                SharePatientFirebaseAPI.REMOVE_BeSharedPatient(patientBeShared.id)
            })
        }
    }
}
