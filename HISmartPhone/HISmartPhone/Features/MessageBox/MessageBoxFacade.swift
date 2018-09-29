//
//  MessageBoxFacade.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/11/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MessageBoxFacade {
    
    private (set) var listNewPartner = [PartnerChat]()
    private (set) var listAllPartner = [PartnerChat]()
    private var total: Int = 0
    private var count: Int = 0
    
    init() {}
    
    func fetchAllPartner(completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        FirebaseAPI.GET_AllUserMessage(completionHandler: { (dataSnapshot) in
            guard let arraySnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else {
                errorHandler()
                return
            }
            
            self.listNewPartner.removeAll()
            self.listAllPartner.removeAll()
            self.total = arraySnapshot.count
            self.count = 0
            
            if arraySnapshot.isEmpty {
                completionHandler()
                return
            }
            
            for snapshot in arraySnapshot {
                if var dicData = snapshot.value as? [String: Any] {
                    let isNewMessage = dicData["isNewMessage"] as? Bool ?? false
                    dicData.removeValue(forKey: "isNewMessage")
                    
                    let key = dicData.keys.sorted(by: { (key1, key2) -> Bool in
                        return key1 > key2
                    }).first ?? ""
                    
                    //Load Message
                    FirebaseAPI.GET_Message(by: key, completionHandler: { (message) in
                        //Load User ownner message
                        NetworkClient.request(urlRequest: APIEndpoint.fetchUserByID, method: .get, parameter: ["id": snapshot.key], completion: { (data) in
                            if let user: User = ParserHelper.parseArrayObject(data).first {
                                let partner = PartnerChat(idPartner: snapshot.key, user: user, endMessage: message, isNewMessage: isNewMessage)
                                
                                if isNewMessage {
                                    self.listNewPartner.append(partner)
                                }
                                
                                self.listAllPartner.append(partner)
                                self.count += 1
                                
                                if self.count == self.total {
                                    self.listNewPartner.sort(by: {
                                        $0.endMessage.timestamp > $1.endMessage.timestamp
                                    })
                                    
                                    self.listAllPartner.sort(by: {
                                        $0.endMessage.timestamp > $1.endMessage.timestamp
                                    })
                                    completionHandler()
                                }
                                
                            } else {
                                self.total -= 1
                            }
                        })
                    }, errorHandler: {
                        self.total -= 1
                    })
                } else {
                    self.total -= 1
                }
            }
        }) {
            errorHandler()
        }
    }
    
    func deleteUserMessage(with partnerId: String, completionHandler: @escaping ()->Void, errorHandler: @escaping ()->Void) {
        let dispathGroup = DispatchGroup()
        let parametersDelete = ["Sender_ID": Authentication.share.currentUserId,
                                "Receiver_ID": partnerId]
        
        DispatchQueue.global(qos: .utility).async {
            dispathGroup.enter()
            
            FirebaseAPI.GET_AllMessageToDelete(by: partnerId) { (dataSnapshot) in
                guard var dicData = dataSnapshot.value as? [String: Any] else {
                    return
                }
                
                dicData.removeValue(forKey: "isNewMessage")
                let keys = dicData.keys
                
                FirebaseAPI.DELETE_UserMessage(width: partnerId, completionHandler: {
                    dispathGroup.leave()
                    
                    FirebaseAPI.GET_AllMessagePartnerWithCurrentUser(by: partnerId, completionHandler: { (dataSnapShot) in
                        if dataSnapShot.childrenCount != 0 {
                            return
                        }
                        
                        FirebaseAPI.DELETE_Messages(with: keys, completionHandler: {
                            //
                        }, errorHandler: {
                            //
                        })
                    })
                }) {
                    errorHandler()
                }
            }
            
            dispathGroup.enter()
            NetworkClient.request(urlRequest: APIEndpoint.chatMessageAPI, method: .delete, parameter: parametersDelete, completion: { (data) in
                dispathGroup.leave()
            })
            
            let statusDelete = dispathGroup.wait(timeout: DispatchTime.now() + 200)
            
            if statusDelete == .success {
                DispatchQueue.main.async {
                    completionHandler()
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler()
                }
            }
        }
        
    }
    
    func updateStatusUserMessage(with partnerId: String) {
        FirebaseAPI.UPDATE_StatusCurrentUserMessage(width: partnerId)
    }
    
}










