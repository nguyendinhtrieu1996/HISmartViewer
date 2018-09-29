//
//  Message.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 12/31/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit

class Message: Mapper {
    
    private (set) var key: String
    private (set) var message: String
    private (set) var fromId: String
    private (set) var toId: String
    private (set) var timestamp: Date
    
    init() {
        self.key = ""
        self.message = ""
        self.fromId = ""
        self.toId = ""
        self.timestamp = Date()
    }
    
    init( message: String, toId: String, timestamp: Date = Date()) {
        self.key = ""
        self.message = message
        self.fromId = Authentication.share.currentUserId
        self.toId = toId
        self.timestamp = timestamp
    }
    
    required init(_ data: [String : Any]) {
        self.key = ""
        self.message = data["message"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        let timeInterval =  data["timestamp"] as? TimeInterval ?? 0
        
        if timeInterval == 0 {
            self.timestamp = (data["timestamp"] as? String ?? "").getDate()
        } else {
            self.timestamp = Date(timeIntervalSince1970: timeInterval)
        }

    }
    
    func setKey(_ key: String) {
        self.key = key
    }
    
    func toString() -> String {
        return "\(fromId) - \(toId)  - mess \(message) - time \(timestamp)"
    }
    
}

//MARK: - TransfromData
extension Message: TransfromData {
    
    func transformDictionaty() -> [String : Any] {
        return [ "fromId": self.fromId,
                 "toId": self.toId,
                 "message": self.message,
                 "timestamp": Date().timeIntervalSince1970
        ]
    }
    
    func transformToAPI() -> [String: Any] {
        return [ "Sender_ID": self.fromId,
                 "Receiver_ID": self.toId,
                 "MsgContent": self.message,
                 "Time": Date().getDesciptionYYYMMddHHmmss()
        ]
    }
    
}



