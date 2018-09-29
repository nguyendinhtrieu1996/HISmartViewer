//
//  HISMartManager.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/16/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HISMartManager {
    
    class var share: HISMartManager {
        struct Static {
            static var instanse = HISMartManager()
        }
        
        return Static.instanse
    }
    
    private init() {
        self.currentPatient = Patient()
        self.currentDoctorID = ""
        self.currentDoctor = User()
    }
    
    //MARK: Variable
    private (set) var currentPatient: Patient
    private (set) var isListPatientVC: Bool = false
    private (set) var currentDoctorID: String
    private (set) var currentDoctor: User
    private (set) var numberNewMessages: Int = 0
    private (set) var isShowTabbarFromSharedVC = false
    
    private var userDefault = UserDefaults.standard
    private (set) var keyDeviceToken: String = "keyDeviceToken"
    private (set) var keyIsSendToken: String = "isSendToken"
    
    var isSendDeviceToken: Bool {
        get {
            if let value = userDefault.value(forKey: keyIsSendToken) as? Bool {
                return value
            }
            
            return false
        }
    }
    
    var deviceToken: String? {
        get {
            return userDefault.value(forKey: keyDeviceToken) as? String
        }
    }
    
    var currentPID_ID: String {
        return self.currentPatient.PID_ID
    }
    
    func obseverMessage() {
        FirebaseAPI.GET_AllUserMessage(completionHandler: { (dataSnapshot) in
            guard let arraySnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.numberNewMessages = 0
            
            for snapshot in arraySnapshot {
                if var dicData = snapshot.value as? [String: Any] {
                    let isNewMessage = dicData["isNewMessage"] as? Bool ?? false
                    
                    if isNewMessage {
                        self.numberNewMessages += 1
                    }
                }
            }
            
            
            NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.obseverMessage), object: nil)
            
        }) {
            //
        }
    }
    
    //MARK: SET
    func updateIsListPatientVC(_ value: Bool) {
        self.isListPatientVC = value
    }
    
    func setCurrentPatient(_ patient: Patient?) {
        guard let patient = patient else {
            let patient = Patient.init(from: Authentication.share.currentUser ?? User())
            self.currentPatient = patient
            self.currentPatient.setBPOPatient(nil)
            return
        }
        
        self.currentPatient = patient
        self.currentPatient.setBPOPatient(nil)
    }
    
    func setCurrentDoctorID(_ id: String) {
        self.currentDoctorID = id
    }
    
    func setCurrentDoctor(_ doctor: User) {
        self.currentDoctor = doctor
    }
    
    func updateIsShowTabbarFromSharedVC() {
        self.isShowTabbarFromSharedVC = true
    }
    
    func resetIsShowTabbarFromSharedVC() {
        self.isListPatientVC = false
    }
    
    public func saveDeviceToken(token: String) {
        userDefault.set(token, forKey: keyDeviceToken)
    }
    
    public func setIsSendDeviceToken(value: Bool = true) {
        userDefault.set(value, forKey: keyIsSendToken)
    }
    
}











