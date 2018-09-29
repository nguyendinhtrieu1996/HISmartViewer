//
//  FIRE_InvoiceAPI.swift
//  StylePizza
//
//  Created by DINH TRIEU on 1/5/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseAPI {
    
    static func GET_AllUserMessage(completionHandler: @escaping(DataSnapshot) -> Void, errorHandler: @escaping() -> Void) {
        FirebaseReference.userMessage_REF.child(Authentication.share.currentUserId).observe(.value) { (dataSnapshot) in
            completionHandler(dataSnapshot)
        }
    }
    
    static func GET_Message(by id: String, completionHandler: @escaping (Message)->Void, errorHandler: @escaping ()->Void) {
        if (id == "") {
            errorHandler()
            return
        }
        FirebaseReference.message_REF.child(id).observeSingleEvent(of: .value) { (snapshot) in
            guard let message: Message = ParserHelper.parseObject(snapshot) else {
                errorHandler()
                return
            }
            completionHandler(message)
            return
        }
    }
    
    static func GET_AllMessage(by partnerId: String, completionHandler: @escaping (DataSnapshot)->Void) {
        FirebaseReference.userMessage_REF.child(Authentication.share.currentUserId).child(partnerId).observe(.value) { (dataSnapshot) in
            completionHandler(dataSnapshot)
        }
    }
    
    static func GET_AllMessageToDelete(by partnerId: String, completionHandler: @escaping (DataSnapshot)->Void) {
        FirebaseReference.userMessage_REF.child(Authentication.share.currentUserId).child(partnerId)
            .observeSingleEvent(of: .value) { (dataSnapshot) in
            completionHandler(dataSnapshot)
        }
    }
    
    static func GET_AllMessagePartnerWithCurrentUser(by partnerId: String, completionHandler: @escaping (DataSnapshot)->Void) {
        FirebaseReference.userMessage_REF.child(partnerId).child(Authentication.share.currentUserId).observeSingleEvent(of: .value) { (dataSnapshot) in
            completionHandler(dataSnapshot)
        }
    }
    
    static func POST_Message(with partnerId: String, dicMessage: [String: Any], completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        FirebaseReference.message_REF.childByAutoId().setValue(dicMessage) { (error, ref) in
            if error != nil {
                errorHandler()
                return
            }
            
            let key = ref.key
            let currentUserId = Authentication.share.currentUserId
            let currentUserPath = currentUserId.appendSlashCharacter(partnerId)
            let partnerPath = partnerId.appendSlashCharacter(currentUserId)
            
            FirebaseReference.userMessage_REF.updateChildValues([
                currentUserPath.appendSlashCharacter(key): true,
                currentUserPath.appendSlashCharacter("isNewMessage"): false,
                partnerPath.appendSlashCharacter(key): true,
                partnerPath.appendSlashCharacter("isNewMessage"): true
                ], withCompletionBlock: { (error, ref) in
                    if error != nil {
                        errorHandler()
                        return
                    }
                    completionHandler()
            })
        }
    }
    
    static func DELETE_UserMessage(width partnerId: String, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        FirebaseReference.userMessage_REF.child(Authentication.share.currentUserId).child(partnerId)
            .removeValue { (error, ref) in
            if error != nil {
                errorHandler()
                return
            }
            completionHandler()
        }
    }
    
    static func DELETE_Messages(with keys: Dictionary<String, Any>.Keys, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        var values = [String: Any?]()
        
        keys.forEach { (key) in
            values.updateValue(nil, forKey: key)
        }
        
        FirebaseReference.message_REF.updateChildValues(values as Any as! [AnyHashable : Any]) { (error, ref) in
            if error != nil {
                errorHandler()
                return
            }
            
            completionHandler()
        }
       
    }
    
    static func UPDATE_StatusCurrentUserMessage(width partnerId: String) {
        let value = ["isNewMessage": false]
        FirebaseReference.userMessage_REF.child(Authentication.share.currentUserId).child(partnerId).observeSingleEvent(of: .value) { (data) in
            if (data.exists()) {
                FirebaseReference.userMessage_REF.child(Authentication.share.currentUserId).child(partnerId)
                    .updateChildValues(value)
            }
        }
    }
    
    static func GET_AllBloodPressures(completionHandler: @escaping (DataSnapshot)->Void, errorHandler: @escaping ()->Void) {
        let id = Authentication.share.currentUserId
        
        if id == "" {
            errorHandler()
            return
        }
        
        FirebaseReference.bloodPressureNotifi.child(id).observe(.value, with: { (dataSnapshot) in
            completionHandler(dataSnapshot)
        }) { (err) in
            errorHandler()
        }
        
    }
    
    static func GET_NewBloodPressures(completionHandler: @escaping (DataSnapshot)->Void, errorHandler: @escaping ()->Void) {
        let id = Authentication.share.currentUserId
        
        if id == "" {
            errorHandler()
            return
        }
        
        FirebaseReference.bloodPressureNotifi.child(id).observe(.childAdded, with: { (dataSnapshot) in
            completionHandler(dataSnapshot)
        }) { (err) in
            errorHandler()
        }
        
    }
    
    public static func UPDATE_statusNotification(key: String, completionHadler: @escaping ()->Void, errorHanlder: @escaping ()->Void) {
        let id = Authentication.share.currentUserId
        
        if id == "" {
            errorHanlder()
            return
        }
        
        FirebaseReference.bloodPressureNotifi.child(id).child(key).child("isNew").setValue(false) { (err, ref) in
            if err != nil {
                errorHanlder()
            }
            completionHadler()
        }
    }
    
    public static func DELETE_Notification(key: String) {
        let id = Authentication.share.currentUserId
        FirebaseReference.bloodPressureNotifi.child(id).child(key).removeValue()
    }
    
}









