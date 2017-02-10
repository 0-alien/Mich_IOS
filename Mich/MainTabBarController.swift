//
//  MainTabBarController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/19/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import AMScrollingNavbar
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    var savedIndex: Int = 0
    var activeImages = [UIImage]()
    var inactiveImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        activeImages.append(UIImage(named: "active_home_icon")!)
        activeImages.append(UIImage(named: "active_vs_icon")!)
        activeImages.append(UIImage(named: "active_camera_icon")!)
        activeImages.append(UIImage(named: "active_mich_icon")!)
        activeImages.append(UIImage(named: "active_user_icon")!)
        inactiveImages.append(UIImage(named: "home_icon")!)
        inactiveImages.append(UIImage(named: "vs_icon")!)
        inactiveImages.append(UIImage(named: "camera_icon")!)
        inactiveImages.append(UIImage(named: "mich_icon")!)
        inactiveImages.append(UIImage(named: "user_icon")!)
        // Do any additional setup after loading the view.
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (viewController is ScrollingNavigationController) {
            (viewController as! ScrollingNavigationController).showNavbar(animated: false)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController is StartViewController) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showChoose"), object: nil)
            return false
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideChoose"), object: nil)
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
