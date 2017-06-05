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
    var StartStoryboardName: String! = nil
    var StartViewControllerName: String! = nil
    var StartingTabIndex: Int! = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        }
        application.registerForRemoteNotifications()
        FIRApp.configure()
        
        let _ = FBSDKLoginButton.classForCoder()
        Fabric.with([Twitter.self])
        
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: "userid") {
            print(stringOne)
            self.StartViewControllerName = "MainTabBarController"
            self.StartStoryboardName = "Userspace"
            self.StartingTabIndex = 0
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        // ar mushaobs user ar aris sheqmnili jer
        if let _ = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            self.StartViewControllerName = "MainTabBarController"
            self.StartStoryboardName = "Userspace"
            self.StartingTabIndex = 1
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        self.StartViewControllerName = "LoginViewController"
        self.StartStoryboardName = "Cabinet"
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        switch (userInfo["type"] as! NSString).intValue {
        case 1: // postis like
            if (application.applicationState == .background || application.applicationState == .inactive) {
                (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 4;
                let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[4] as! UINavigationController);
                vc.popToRootViewController(animated: false)
                let userViewController: UserPicturesCollectionViewController = vc.topViewController as! UserPicturesCollectionViewController
                userViewController.performSegue(withIdentifier: "showpostnotification", sender: Int((userInfo["id"] as! NSString).intValue))
                if application.applicationIconBadgeNumber > 0 {
                    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
                }
            }
            else {
                (window?.rootViewController as! ScrollingViewController).incrementNotificationCount(by: 1)
            }
            break;
        case 2: // comntaris damateba
            if (application.applicationState == .background || application.applicationState == .inactive) {
                processCommentNotification(application, commentId: Int((userInfo["commentid"] as! NSString).intValue), postId: Int((userInfo["postid"] as! NSString).intValue))
            }
            else {
                (window?.rootViewController as! ScrollingViewController).incrementNotificationCount(by: 1)
            }
            break;
        case 3: // comentaris like
            if (application.applicationState == .background || application.applicationState == .inactive) {
                processCommentNotification(application, commentId: Int((userInfo["commentid"] as! NSString).intValue), postId: Int((userInfo["postid"] as! NSString).intValue))
            }
            else {
                (window?.rootViewController as! ScrollingViewController).incrementNotificationCount(by: 1)
            }
            break;
        default:
            break;
        }
        MichNotificationsTransport.markSingleNotificationSeen(token: token!, notificationId: Int((userInfo["notificationid"] as! NSString).intValue), successCallbackForMarkSingleNotificationSeen: {}, errorCallbackForMarkSingleNotificationSeen: {_ in })
    }
    
    

    private func processCommentNotification(_ application: UIApplication, commentId: Int, postId: Int) {
        (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 4;
        let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[4] as! UINavigationController);
        vc.popToRootViewController(animated: false)
        let userViewController: UserPicturesCollectionViewController = vc.topViewController as! UserPicturesCollectionViewController
        userViewController.destinationCommentId = commentId
        userViewController.destinationPostId = postId
        userViewController.performSegue(withIdentifier: "showcommentnotification", sender: userViewController)
        if application.applicationIconBadgeNumber > 0 {
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1
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
