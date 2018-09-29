//
//  PartnerChat.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/11/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class PartnerChat {
    private (set) var idPartner: String
    private (set) var user: User
    private (set) var endMessage: Message
    private (set) var isNewMessage: Bool
    
    init() {
        self.idPartner = ""
        self.user = User()
        self.endMessage = Message()
        self.isNewMessage = false
    }
    
    init(idPartner: String, user: User, endMessage: Message, isNewMessage: Bool) {
        self.idPartner = idPartner
        self.user = user
        self.endMessage = endMessage
        self.isNewMessage = isNewMessage
    }
    
    init(from user: User) {
        self.user = user
        self.idPartner = user.userID
        self.endMessage = Message()
        self.isNewMessage = false
    }
    
}
