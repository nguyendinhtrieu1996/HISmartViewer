//
//  Authentication.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/22/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class Authentication {
    
    class var share: Authentication {
        struct Static {
            static var instance = Authentication()
        }
        return Static.instance
    }
    
    private init() {
        self.patientRegister = Patient()
    }
    
    private (set) var patientRegister: Patient
    
    var currentUser: User? {
        get {
            return self.getCurrentUser()
        }
    }
    
    var typeUser: TypeUser? {
        get {
            let user = self.getCurrentUser()
            
            if user?.typeUser == .doctor {
                HISMartManager.share.setCurrentDoctorID(user?.userID ?? "")
                HISMartManager.share.setCurrentDoctor(user ?? User())
            }
            
            return user?.typeUser
        }
    }
    
    var currentUserId: String {
        get {
            return self.currentUser?.userID ?? ""
        }
    }
    
    private let saveUserKey = "currentUserKey"
    
   
    //MARK: SET
    
    func signIn(_ username: String, _ password: String, completionHanlder: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        let dispathGroup = DispatchGroup()
        
        NetworkClient.request(urlRequest: APIEndpoint.login, method: .post, parameter: ["userName": username, "password": password]) { (data) in
            if let user: User = ParserHelper.parseArrayObject(data).first {
                self.saveCurrentUserToUserDefault(user)
                
                BloodPressureNotifiHelper.shared.getAllBloodPressureNotification()
                
                DispatchQueue.global(qos: .userInitiated).async {
                    if self.typeUser == .patient {
                        dispathGroup.enter()
                        SharePatientFacade().fetchPatient(by: user.userID, completion: { (patient) in
                            HISMartManager.share.setCurrentPatient(patient)
                            dispathGroup.leave()
                        }, errorHandler: {
                            dispathGroup.leave()
                        })
                    }
                    
                    if !HISMartManager.share.isSendDeviceToken && HISMartManager.share.deviceToken != nil {
                        dispathGroup.enter()
                        let params = DeviceIDHelper.getParams(user, self.typeUser ?? TypeUser.patient)
                        
                        NetworkClient.request(urlRequest: APIEndpoint.sendToken, method: .post, parameter: params, completion: { (data) in
                            HISMartManager.share.setIsSendDeviceToken()
                            dispathGroup.leave()
                        })
                    }
                    
                    BloodPressureNotifiHelper.shared.getAllBloodPressureNotification()
                    
                    let _ = dispathGroup.wait(timeout: .now() + 200)
                    
                    DispatchQueue.main.async {
                        completionHanlder()
                    }
                }
            } else {
                errorHandler()
            }
        }
    }
    
    func signOut() {
        let logoutParams: [String: Any] = getParamsLogout()
        NetworkClient.request(urlRequest: APIEndpoint.logout, method: .post, parameter: logoutParams) { (data) in
            //
        }
        
        let params = DeviceIDHelper.getParamsRemoveToken()
        
        NetworkClient.request(urlRequest: APIEndpoint.sendToken, method: .post, parameter: params, completion: { (data) in
            HISMartManager.share.setIsSendDeviceToken(value: false)
        })
    
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: self.saveUserKey)
        defaults.synchronize()
    }
    
    func register(with pass: String, completion: @escaping ()->Void, error: @escaping ()->Void) {
        self.patientRegister.setPassword(pass)
        let dic = self.patientRegister.transformDictionaty()
        
        NetworkClient.request(urlRequest: APIEndpoint.patientRegister, method: .post, parameter: dic) { (data) in
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? String else {
                error()
                return
            }
            
            if result == StatusRequest.fail.rawValue {
                error()
            } else {
                self.signIn(self.patientRegister.patient_ID, self.patientRegister.patient_Password, completionHanlder: {
                    self.patientRegister = Patient()
                    completion()
                }, errorHandler: {
                    error()
                })
            }
        }
    }
    
    func setPatientRegidter(_ patient: Patient) {
        self.patientRegister = patient
    }
    
    //MARK: PRIVATE
    func saveCurrentUserToUserDefault(_ user: User) {
        let archiveObject = NSKeyedArchiver.archivedData(withRootObject: user)
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: self.saveUserKey)
        defaults.set(archiveObject, forKey: self.saveUserKey)
        defaults.synchronize()
    }
    
    private func getCurrentUser() -> User? {
        guard let decodeNSDataBlob = UserDefaults.standard.object(forKey: self.saveUserKey) as? NSData else {
            return nil
        }
        
        guard let savedUser = NSKeyedUnarchiver.unarchiveObject(with: decodeNSDataBlob as Data) as? User else {
            return nil
        }
        
        return savedUser
    }
    
    private func getParamsLogout() -> [String: Any] {
        var params = [String: Any]()
        var typeUser: Int
        
        params["userName"] = currentUser?.userName ?? ""
        
        self.typeUser == TypeUser.patient ? (typeUser = 1) : (typeUser = 0)
        
        params["typeuser"] = typeUser
        
        return params
    }
    
}







