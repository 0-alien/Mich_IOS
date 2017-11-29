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
import Alamofire
import GoogleMaps
import GooglePlaces
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var savedIndex: Int! = 0
    var window: UIWindow?
    var token:String?
    var waiting: Bool! = false
    var unseenNotificationCount: Int! {
        didSet {
            UIApplication.shared.applicationIconBadgeNumber = self.unseenNotificationCount
        }
    }
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
        GMSServices.provideAPIKey("AIzaSyDw-Wl1Pa705MWLf2qN8L3GFB86_dfw0qY")
        GMSPlacesClient.provideAPIKey("AIzaSyDw-Wl1Pa705MWLf2qN8L3GFB86_dfw0qY")
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
        }
        application.registerForRemoteNotifications()
        FIRApp.configure()
        
        let defaults = UserDefaults.standard
        if let userId = defaults.string(forKey: "userid"), let tk = defaults.string(forKey: "token") {
            self.waiting = true
            self.token = tk
            MichTransport.getuser(token: tk, id: Int(userId)!, successCallbackForgetuser: self.onGetUserSuccess, errorCallbackForgetuser: self.onError)
            self.StartViewControllerName = "ScrollingViewController"
            self.StartStoryboardName = "Userspace"
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: .firInstanceIDTokenRefresh, object: nil)
        
        let _ = FBSDKLoginButton.classForCoder()
        Fabric.with([Twitter.self])
        self.StartViewControllerName = "LoginViewController"
        self.StartStoryboardName = "Cabinet"
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let vc = window?.rootViewController as? ViewController {
            vc.shouldShowNotification = true
            vc.userInfo = userInfo
        }
        else if let _ = window?.rootViewController as? ScrollingViewController {
            self.processNotificationAfterLoading(application, userInfo: userInfo, onStartUp: false)
        }
        // no way
    }
    
    

    private func processCommentNotification(_ application: UIApplication, commentId: Int, postId: Int) {
        (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 4;
        let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[4] as! UINavigationController);
        vc.popToRootViewController(animated: false)
        let userViewController: UserPicturesCollectionViewController = vc.topViewController as! UserPicturesCollectionViewController
        userViewController.destinationCommentId = commentId
        userViewController.destinationPostId = postId
        userViewController.performSegue(withIdentifier: "showcommentnotification", sender: userViewController)
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
    
    func onGetUserSuccess(user: User) {
        self.user = user
        print("waikitxa save logini jer")
        if let contents = FIRInstanceID.instanceID().token() {
            MichTransport.updateFirebaseToken(token: self.token!, firToken: contents, successCallbackForGetBattles: {}, errorCallbackForGetBattles: {_ in })
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "finishedLoading"), object: nil)
    }
    
    
    func onError(error: DefaultError) {
        self.StartViewControllerName = "LoginViewController"
        self.StartStoryboardName = "Cabinet"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "finishedLoading"), object: nil)
    }
    
    func processNotificationAfterLoading(_ application: UIApplication, userInfo: [AnyHashable : Any], onStartUp: Bool) {
        print(userInfo)
        switch (userInfo["type"] as! NSString).intValue {
        case 1:
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 4;
                let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[4] as! UINavigationController);
                vc.popToRootViewController(animated: false)
                let userViewController: UserPicturesCollectionViewController = vc.topViewController as! UserPicturesCollectionViewController
                userViewController.performSegue(withIdentifier: "showpostnotification", sender: Int((userInfo["postid"] as! NSString).intValue))
            }
            break;
        case 2: // comentaris damateba
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                processCommentNotification(application, commentId: Int((userInfo["commentid"] as! NSString).intValue), postId: Int((userInfo["postid"] as! NSString).intValue))
            }
            break;
        case 3: // comentaris like
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                processCommentNotification(application, commentId: Int((userInfo["commentid"] as! NSString).intValue), postId: Int((userInfo["postid"] as! NSString).intValue))
            }
            break;
        case 4: // follow 
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                
            }
            break;
        case 5: //vs invite
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 1
                let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[1] as! UINavigationController)
                vc.popToRootViewController(animated: false)
                let vsViewController: VSHomeViewController = vc.topViewController as! VSHomeViewController
                vsViewController.destinationBattleId = Int((userInfo["battleid"] as! NSString).intValue)
                vsViewController.performSegue(withIdentifier: "showvsnotification", sender: vsViewController)
            }
            break;
        case 6: //vs accept
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 1
                let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[1] as! UINavigationController)
                vc.popToRootViewController(animated: false)
                let vsViewController: VSHomeViewController = vc.topViewController as! VSHomeViewController
                vsViewController.destinationBattleId = Int((userInfo["battleid"] as! NSString).intValue)
                vsViewController.performSegue(withIdentifier: "showvsnotification", sender: vsViewController)
            }
            break
        case 7:
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 1
                let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[1] as! UINavigationController)
                vc.popToRootViewController(animated: false)
            }
            break
        case 8: //battle finish
            if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
                (window?.rootViewController as! ScrollingViewController).myTabBar?.selectedIndex = 1
                let vc = ((window?.rootViewController as! ScrollingViewController).myTabBar?.viewControllers?[1] as! UINavigationController)
                vc.popToRootViewController(animated: false)
                let vsViewController: VSHomeViewController = vc.topViewController as! VSHomeViewController
                vsViewController.destinationBattleId = Int((userInfo["battleid"] as! NSString).intValue)
                vsViewController.performSegue(withIdentifier: "showvsnotification", sender: vsViewController)
            }
            break
        default:
            break;
        }
        // notification count
        if (application.applicationState == .background || application.applicationState == .inactive || onStartUp) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            MichNotificationsTransport.markSingleNotificationSeen(token: token!, notificationId: Int((userInfo["notificationid"] as! NSString).intValue), successCallbackForMarkSingleNotificationSeen: {}, errorCallbackForMarkSingleNotificationSeen: {_ in })
            var aps = (userInfo["aps"] as! [AnyHashable : Any]);
            (window?.rootViewController as! ScrollingViewController).setNotificationCount(count: (aps["badge"] as! Int) - 1) // naxvis gamo chairto
        } else {
            var aps = (userInfo["aps"] as! [AnyHashable : Any]);
            (window?.rootViewController as! ScrollingViewController).setNotificationCount(count: (aps["badge"] as! Int))
            print(aps)
        }
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        guard let contents = FIRInstanceID.instanceID().token()
            else {
                return
        }
        if self.token != nil {
            MichTransport.updateFirebaseToken(token: self.token!, firToken: contents, successCallbackForGetBattles: {}, errorCallbackForGetBattles: onError)
        }
    }
    
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


