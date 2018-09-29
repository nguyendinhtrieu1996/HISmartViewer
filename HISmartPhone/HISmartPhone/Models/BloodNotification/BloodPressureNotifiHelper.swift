//
//  BoolPressureNotifi.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 4/1/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

class BloodPressureNotifiHelper {
    
    class var shared: BloodPressureNotifiHelper {
        struct Static {
            static var instance = BloodPressureNotifiHelper()
        }
        return Static.instance
    }
    
    private (set) var bloodPressures = [BloodPressureNotification]()
    private (set) var newBPNotifications = [BloodPressureNotification]()
    
    private init() {
        
    }
    
    func handleNewBloodPressure() {
        FirebaseAPI.GET_NewBloodPressures(completionHandler: { (dataSnapshot) in
            AudioHelper.shared.play()
        }) {
            //
        }
    }
    
    @objc func getAllBloodPressureNotification() {
        handleNewBloodPressure()
        
        FirebaseAPI.GET_AllBloodPressures(completionHandler: { (dataSnapshot) in
            self.bloodPressures.removeAll()
            self.newBPNotifications.removeAll()
            
            guard let data = dataSnapshot.value as? [String: Any] else {
                NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateNotification), object: nil)
                return
            }
            
            for (key, value) in data {
                if let dicData = value as? [String: Any] {
                    let blood = BloodPressureNotification.init(dicData)
                    blood.setKey(key)
                    self.bloodPressures.append(blood)
                }
            }
            
            self.bloodPressures = self.bloodPressures.sorted(by: { (bf1, bf2) -> Bool in
                return bf1.createDate > bf2.createDate
            })
            
            for BP in self.bloodPressures {
                if BP.isNew {
                    self.newBPNotifications.append(BP)
                }
            }
            
            if (self.newBPNotifications.count > 0) {
                NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.showAlertBPNotification), object: nil)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateNotification), object: nil)
        }) {
            
        }
    }
    
    public func updateStatusNotification(completionHanlder: @escaping ()->Void) {
        let dispathGroup = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async {
            for BP in self.bloodPressures {
                if BP.isNew {
                    dispathGroup.enter()
                    FirebaseAPI.UPDATE_statusNotification(key: BP.key, completionHadler: {
                        dispathGroup.leave()
                    }, errorHanlder: {
                        dispathGroup.leave()
                    })
                }
            }
            
            let _ = dispathGroup.wait(timeout: .now() + 1000);
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name.init(Notification.Name.updateNotification), object: nil)
                completionHanlder()
            }
        }
        
    }
    
}
