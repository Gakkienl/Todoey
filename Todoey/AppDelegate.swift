//
//  AppDelegate.swift
//  Todoey
//
//  Created by G. A. KAMPHUIS on 06/05/2018.
//  Copyright © 2018 GAKKIE. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //print(Realm.Configuration.defaultConfiguration.fileURL)
//        do {
//            let realm = try Realm()
//        } catch {
//            print("Error initialising new Realm: \(error)")
//
//        }
        
        return true
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
 
    }


}

