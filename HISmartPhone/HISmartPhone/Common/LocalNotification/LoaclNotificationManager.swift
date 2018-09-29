//
//  LoaclNotificationManager.swift
//  HISmartPhone
//
//  Created by Huỳnh Công Thái on 1/27/18.
//  Copyright © 2018 MACOS. All rights reserved.
//


import UIKit
import UserNotifications

class LocalNotificationManager: NSObject {
    
    static let share = LocalNotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
//        self.addNotificationCustomUICategories()
    }
    
    private func addNotificationCustomUICategories() {
        let actionShow = UNNotificationAction(identifier: "show", title: "Hiển thị", options: .foreground)
        let actionCancel = UNNotificationAction(identifier: "cancel", title: "Huỷ", options: .foreground)
        let category = UNNotificationCategory(identifier: "category", actions: [actionShow, actionCancel], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func registerNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (bool, err) in
        }
    }
    
    func PushNotificationLocal(_ title: String, subTitle: String, body: String, time: TimeInterval) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subTitle
            content.body = body
            content.badge = 3
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = "category"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            let request = UNNotificationRequest(identifier: "time", content: content, trigger: trigger)
            DispatchQueue.main.asyncAfter(deadline: .now() + time*1.5, execute: {
                center.add(request)
            })
        } else {
            // ios 9
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
            notification.alertTitle = title
            notification.alertAction = subTitle
            notification.alertBody = body
            notification.category = "category"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
}

extension LocalNotificationManager:UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "show":
            print("action1")
            break
        case "cancel":
            print("action2")
            break
        default:
            break
        }
    }
}
