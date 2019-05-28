//
//  AppDelegate.swift
//  BarPass
//
//  Created by Bruno Lopes on 14/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import UIKit
import OneSignal
import FacebookCore
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.keyboardAppearance = UIKeyboardAppearance.dark
        IQKeyboardManager.shared.overrideKeyboardAppearance = true
        IQKeyboardManager.shared.enable = true
        
        let navController = UINavigationController()
        
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.orange
        navController.navigationBar.backgroundColor = UIColor.white
        navController.setNavigationBarHidden(true, animated: false)
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            // Fallback on earlier versions
        }

        if #available(iOS 11.0, *) {
            navController.navigationBar.prefersLargeTitles = false
            navController.navigationBar.setBackgroundImage(UIImage(named: "navBackGround"), for: .default)
            
        } else {
            // Fallback on earlier versions
        }
        
        //set waves image under navigation bar
//        let originX = navController.navigationBar.bounds.origin.x
//        let originY = navController.navigationBar.frame.height
//        let wavesView = UIView(frame: CGRect(x: 0, y: 20, width: self.window?.frame.width ?? 300.0, height: 136.4))
//        let wavesImage = UIImage(named: "navBackGround")
//        let imageView = UIImageView()
//        imageView.frame = wavesView.frame
//        imageView.contentMode = .scaleAspectFill
//        imageView.image = wavesImage
//
//        wavesView.addSubview(imageView)
//        navController.navigationBar.addSubview(wavesView)
        
        navController.pushViewController(InitialViewController.instantiate("Login"), animated: false)
        
        // create a basic UIWindow and activate it
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "b7898737-2dd4-4d23-a8f7-70094dd8f08b",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }

}

