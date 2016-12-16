//
//  AppDelegate.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation
import Firebase
import GoogleMaps
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        FIRApp.configure()
        
        FIRDatabase.database().persistenceEnabled = true
        
        GMSServices.provideAPIKey(Keys.firebase)
        
        Fabric.with([Crashlytics.self])
    }

}
