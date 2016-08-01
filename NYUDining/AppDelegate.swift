//
//  AppDelegate.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation

import Firebase
import FBSDKCoreKit
import Fabric
import Crashlytics

/*
 NSUserDefaults values -
 FCMToken
 School_Year
 School_Major
 Interests
 possibleSchool
 School
 FbUserId
 FCMToken
 FbUserName
 FbUserPicture
 
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let tabBarController = TabBarViewController()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        Fabric.with([Crashlytics.self])

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                let token = FIRInstanceID.instanceID().token()!
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(token, forKey: "FCMToken")
                print("Connected to FCM.")
            }
        }
    }
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()!
        print("InstanceID token: \(refreshedToken)")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(refreshedToken, forKey: "FCMToken")
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
}

