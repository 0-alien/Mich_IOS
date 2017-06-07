//
//  ViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import Firebase
import Social

class ViewController: UIViewController {

    var userInfo: [AnyHashable : Any]! = nil
    var shouldShowNotification: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showStartViewController), name: NSNotification.Name(rawValue: "finishedLoading"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!(UIApplication.shared.delegate as! AppDelegate).waiting) {
            let storyboard = UIStoryboard(name: (UIApplication.shared.delegate as! AppDelegate).StartStoryboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName) as! LoginViewController
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
            self.dismiss(animated: false, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showStartViewController() {
        if (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName == "LoginViewController" {
            let storyboard = UIStoryboard(name: (UIApplication.shared.delegate as! AppDelegate).StartStoryboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName) as! LoginViewController
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        }
        else if (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName == "ScrollingViewController" {
            let storyboard = UIStoryboard(name: (UIApplication.shared.delegate as! AppDelegate).StartStoryboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName) as! ScrollingViewController
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
            if shouldShowNotification {
                NSLog("1231231232131231232131231231232132131")
                shouldShowNotification = false
                (UIApplication.shared.delegate as! AppDelegate).processNotificationAfterLoading(UIApplication.shared, userInfo: userInfo, onStartUp: true)
            }
        }
        self.dismiss(animated: false, completion: nil)
    }

}

