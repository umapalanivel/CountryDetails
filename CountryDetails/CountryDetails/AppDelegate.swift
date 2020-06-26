//
//  AppDelegate.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame:UIScreen.main.bounds)
        if let windowScreen  = window {
            windowScreen.rootViewController = ViewController()
            windowScreen.backgroundColor = UIColor.white
            windowScreen.makeKeyAndVisible()
        }
        return true
    }

   

    


}

