//
//  AppDelegate.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Fabric
import TwitterKit
import GoogleSignIn
import Firebase
import PusherSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var token:String?
    var user: User? {
        didSet {
            if user != nil {
                
            }
        }
    }
    var pusher: Pusher! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.applicationIconBadgeNumber = 0
        
        /*if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            window?.rootViewController = vc
            (window?.rootViewController as? ScrollingViewController)?.myTabBar?.selectedIndex = 1
        }*/
        
        let _ = FBSDKLoginButton.classForCoder()
        Fabric.with([Twitter.self])
        FIRApp.configure()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(_ application: UIApplication,
                              didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                              fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        
    }
    
    
    func setUpNotifications() {
        self.pusher = Pusher(key: "631cad75e06b7aa8904a", options: PusherClientOptions(host: .cluster("eu")))
        let channel = pusher.subscribe(String((self.user?.id)! + 0))
        let _ = channel.bind(eventName: "invitation", callback: inviteRecieved)
        pusher.connect()
    }
    
    func inviteRecieved(data: Any?) -> Void {
        if let data = data as? [String : Any] {
            if let message = data["battle"] as? Int {
                print(message)
            }
        }
        if let vc = (self.window?.rootViewController as? ScrollingViewController) {
            if (vc.myTabBar?.tabBar.items?[4].badgeValue == nil) {
                vc.myTabBar?.tabBar.items?[4].badgeValue = "1"
            }
            else {
                vc.myTabBar?.tabBar.items?[4].badgeValue = String(Int((vc.myTabBar?.tabBar.items?[4].badgeValue)!)! + 1)
            }
            vc.myMenu?.incrementNotificationCount(by: 1)
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
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
        FBSDKAppEvents.activateApp()
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

