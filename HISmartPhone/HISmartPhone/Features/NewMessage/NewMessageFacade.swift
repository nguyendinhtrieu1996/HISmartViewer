//
//  NewMessageFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/12/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewMessageFacade {
    
    private var totalNumberMessage: Int = 0
    private var countMessage: Int = 0
    private (set) var listMessage = [Message]()
    private (set) var listUser = [User]()
    
    func loadAllUserCanSendMessage(completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        self.listUser.removeAll()
        let parameter = ["id": Authentication.share.currentUserId]
        let dispathGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .utility).async {
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.fetchAllPartnerChat, method: .get, parameter: parameter) { (data) in
                self.listUser += ParserHelper.parseArrayObject(data)
                dispathGroup.leave()
            }
            
            dispathGroup.enter()
            
            if Authentication.share.typeUser == .patient {
                NetworkClient.request(urlRequest: APIEndpoint.getListDoctorByPIDID, method: .get, parameter: parameter, completion: { (data) in
                    self.listUser += ParserHelper.parseArrayObject(data)
                    dispathGroup.leave()
                })
            } else {
                NetworkClient.request(urlRequest: APIEndpoint.getlistDoctorChat, method: .get, parameter: parameter, completion: { (data) in
                    self.listUser += ParserHelper.parseArrayObject(data)
                    dispathGroup.leave()
                })
            }
            
        
            let status = dispathGroup.wait(timeout: .now() + 10000)
            
            if status == .success {
                DispatchQueue.main.async {
                    self.normalizeListUser()
                    completionHandler()
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler()
                }
            }
        }
        
        
    }
    
    func loadAllMessageFromDB(width partnerId: String, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        self.listMessage.removeAll()
        let paramsOwnerToPartner = ["senderID": Authentication.share.currentUserId,
                                    "receiverID": partnerId]
        let paramsPartnerToOwner = ["senderID": partnerId,
                                    "receiverID": Authentication.share.currentUserId]
        let dispathGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async {
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.chatMessageAPI, method: .get, parameter: paramsOwnerToPartner) { (data) in
                let messages: [Message] = ParserHelper.parseArrayObject(data)
                self.listMessage += messages
                dispathGroup.leave()
            }
            
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.chatMessageAPI, method: .get, parameter: paramsPartnerToOwner) { (data) in
                let messages: [Message] = ParserHelper.parseArrayObject(data)
                self.listMessage += messages
                dispathGroup.leave()
            }
            
            let statusMessage = dispathGroup.wait(timeout: .now() + 1000)
            
            DispatchQueue.main.async {
                if statusMessage == DispatchTimeoutResult.timedOut {
                    errorHandler()
                } else {
                    self.listMessage.sort(by: { (m1, m2) -> Bool in
                        return m1.timestamp < m2.timestamp
                    })
                    completionHandler()
                }
            }
        }
        
    }
    
    func loadAllMessage(width partnerId: String, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        
        FirebaseAPI.GET_AllMessage(by: partnerId) { (dataSnapshot) in
            guard var dicData = dataSnapshot.value as? [String: Any] else {
                errorHandler()
                return
            }
            
            dicData.removeValue(forKey: "isNewMessage")
            let keys = dicData.keys
            self.totalNumberMessage = keys.count
            self.countMessage = 0
            self.listMessage.removeAll()
            
            for key in keys {
                FirebaseAPI.GET_Message(by: key, completionHandler: { (message) in
                    self.countMessage += 1
                    self.listMessage.append(message)
                    
                    if self.countMessage == self.totalNumberMessage {
                        self.listMessage.sort(by: {
                            $0.timestamp < $1.timestamp
                        })
                        
                        completionHandler()
                    }
                }, errorHandler: {
                    //Error
                    self.countMessage -= 1
                })
            }
        }
    }
    
    func sendMessage(with partnerId: String, message: Message, completionHadler: @escaping ()->Void, errorHanlder: @escaping ()->Void) {
        let dispathGroup = DispatchGroup()
        var status = StatusRequest.success
        
        DispatchQueue.global(qos: .userInitiated).async {
            dispathGroup.enter()
            FirebaseAPI.POST_Message(with: partnerId, dicMessage: message.transformDictionaty(), completionHandler: {
                //Success
                dispathGroup.leave()
            }) {
                //Error
                status = .fail
                dispathGroup.leave()
            }
            
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.chatMessageAPI, method: .post, parameter: message.transformToAPI()) { (data) in
                if let result = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? String {
                    if result == StatusRequest.fail.rawValue {
                        status = .fail
                    }
                }
                
                dispathGroup.leave()
            }
            
            let x = dispathGroup.wait(timeout: .now() + 200)
            
            DispatchQueue.main.async {
                if x == DispatchTimeoutResult.success {
                    if status == .success {
                        completionHadler()
                    } else {
                        errorHanlder()
                    }
                } else {
                    errorHanlder()
                }
            }
        }
        
        
    }
    
    func updateStatusUserMessage(with partnerId: String) {
        
        FirebaseAPI.UPDATE_StatusCurrentUserMessage(width: partnerId)
    }
    
    private func normalizeListUser() {
        var newList = [User]()
        
        for i in 0..<listUser.count {
            if (!newList.contains(listUser[i])) {
                newList.append(listUser[i])
            }
        }
        
        listUser.removeAll()
        listUser += newList
    }
    
}






