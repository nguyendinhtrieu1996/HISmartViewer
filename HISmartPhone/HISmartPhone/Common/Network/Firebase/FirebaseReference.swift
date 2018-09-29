//
//  FIR_User.swift
//  StylePizza
//
//  Created by DINH TRIEU on 1/11/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseReference {
    static var root_REF = Database.database().reference()
    static var message_REF = Database.database().reference().child("messages")
    static var userMessage_REF = Database.database().reference().child("user-message")
    static var sharePatient_REF = Database.database().reference().child("share-patient")
    static var bloodPressureNotifi = Database.database().reference().child("notifi-blood-pressure")
}
