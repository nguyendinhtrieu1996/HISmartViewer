//
//  AppDelegate.swift
//  HISmartPhone
//
//  Created by MACOS on 12/18/17.
//  Copyright © 2017 MACOS. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    
    private func firebaseNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LocalNotificationManager.share.registerNotification()
        IQKeyboardManager.sharedManager().enable = true
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        self.firebaseNotification(application)

        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: Theme.shared.defaultBGColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: Dimension.shared.smallCaptionFontSize)], for: .normal)

        UINavigationBar.appearance().barTintColor = Theme.shared.primaryColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = Theme.shared.defaultTextColor
        
        self.window?.rootViewController = UINavigationController(rootViewController: ListPatientController())
//
//        if let user = Authentication.share.currentUser {
//            //Sign In
//            Authentication.share.signIn(user.userName, user.password, completionHanlder: {
//
//            }) {
//            }
//
//            HISMartManager.share.obseverMessage()
//
////            if Authentication.share.typeUser == .doctor {
////                _ = BeSharedManager.share
////                self.window?.rootViewController = UINavigationController(rootViewController: ListPatientController())
////            } else {
////                let user = Authentication.share.currentUser ?? User()
////                HISMartManager.share.setCurrentPatient(Patient.init(from: user))
////                self.window?.rootViewController = TabBarController()
////            }
//        } else {
//            window?.rootViewController = UINavigationController(rootViewController: LoginController())
//        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        HISMartManager.share.saveDeviceToken(token: fcmToken)
         print("Firebase registration token: \(fcmToken)")
    }

}
