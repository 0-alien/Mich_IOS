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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName == "LoginViewController" {
            let storyboard = UIStoryboard(name: (UIApplication.shared.delegate as! AppDelegate).StartStoryboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName) as! LoginViewController
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        }
        else if (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName == "MainTabBarController" {
            let storyboard = UIStoryboard(name: (UIApplication.shared.delegate as! AppDelegate).StartStoryboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: (UIApplication.shared.delegate as! AppDelegate).StartViewControllerName) as! ScrollingViewController
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        }
        self.dismiss(animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

