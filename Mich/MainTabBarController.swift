//
//  MainTabBarController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/19/16.
//  Copyright © 2016 Gigi. All rights reserved.
//


import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    var activeImages = [UIImage]()
    var inactiveImages = [UIImage]()
    override var selectedIndex: Int {
        didSet {
            (UIApplication.shared.delegate as! AppDelegate).savedIndex = selectedIndex
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        activeImages.append(UIImage(named: "active_home_icon")!)
        activeImages.append(UIImage(named: "active_vs_icon")!)
        activeImages.append(UIImage(named: "active_plus_icon")!)
        activeImages.append(UIImage(named: "active_mich_icon")!)
        activeImages.append(UIImage(named: "active_user_icon")!)
        inactiveImages.append(UIImage(named: "home_icon")!)
        inactiveImages.append(UIImage(named: "vs_icon")!)
        inactiveImages.append(UIImage(named: "plus_icon")!)
        inactiveImages.append(UIImage(named: "mich_icon")!)
        inactiveImages.append(UIImage(named: "user_icon")!)
        // Do any additional setup after loading the view.
    
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        /*if tabBarController.selectedIndex == 4 {
            tabBarController.tabBar.items?[4].badgeValue = nil
        }*/
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController is CameraLoadViewController) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showChoose"), object: nil)
            return false
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideChoose"), object: nil)
        if (tabBarController.selectedIndex == 0 && (viewController as! UINavigationController).viewControllers[0] is PostsViewController) {
            let vc: PostsViewController = ((viewController as! UINavigationController).viewControllers[0]) as! PostsViewController
            if (((viewController as! UINavigationController).viewControllers[0]) as! PostsViewController).posts.count > 0 {
                vc.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        return true
    }
    
    func setNotificationCount(count: Int) {
        if count == 0 {
            self.tabBar.items?[4].badgeValue = nil
        }
        else if count < 0 {
            return
        }
        else {
            self.tabBar.items?[4].badgeValue = String(count)
        }
    }
    
    func incrementNotificationCount(by: Int) {
        var count: Int;
        if self.tabBar.items?[4].badgeValue == nil {
            count = 0;
        }
        else {
            count = Int((self.tabBar.items?[4].badgeValue)!)!
        }
        count = count + by;
        self.setNotificationCount(count: count)
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
