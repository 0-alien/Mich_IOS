//
//  ScrollingViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/6/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class ScrollingViewController: UIViewController, UIScrollViewDelegate, LogoutDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    var myTabBar: MainTabBarController?
    var myMenu: SlidingMenuViewController?
    
    var tap: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showNotifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.hideScrollingMenu), name: NSNotification.Name(rawValue: "showHelp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.enableScrolling), name: NSNotification.Name(rawValue: "enableScrolling"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollingViewController.disableScrolling), name: NSNotification.Name(rawValue: "disableScrolling"), object: nil)
        tap = UITapGestureRecognizer(target: self, action: #selector(ScrollingViewController.hideScrollingMenu))
        leftView.addGestureRecognizer(tap)
        tap.isEnabled = false
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func disableScrolling() {
        scrollView.isScrollEnabled = false
    }
    func enableScrolling() {
        scrollView.isScrollEnabled = true
    }
    
    func hideScrollingMenu() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = false
        if (scrollView.contentOffset.x == rightView.frame.width) {
            for i in 0 ..< leftView.subviews.count {
                leftView.subviews[i].isUserInteractionEnabled = false
            }
            tap.isEnabled = true
        }
        else if (scrollView.contentOffset.x == 0) {
            for i in 0 ..< leftView.subviews.count {
                leftView.subviews[i].isUserInteractionEnabled = true
            }
            tap.isEnabled = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == 0) {
            for i in 0 ..< leftView.subviews.count {
                leftView.subviews[i].isUserInteractionEnabled = true
            }
            tap.isEnabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Notifications
    func setNotificationCount(count: Int) {
        myTabBar?.setNotificationCount(count: count)
        myMenu?.setNotificationCount(count: count)
    }
    
    func incrementNotificationCount(by: Int) {
        //myTabBar?.incrementNotificationCount(by: by)
        myMenu?.incrementNotificationCount(by: by)
    }
    // MARK: - logOut Delegate
    func logOut() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userid")
        defaults.removeObject(forKey: "token")
        let storyboard = UIStoryboard(name: "Cabinet", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        (UIApplication.shared.delegate as! AppDelegate).user = nil
        (UIApplication.shared.delegate as! AppDelegate).token = nil
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedTabBar" {
            self.myTabBar = (segue.destination as! MainTabBarController)
        }
        else if segue.identifier == "EmbedMenu" {
            self.myMenu = (segue.destination as! SlidingMenuViewController)
            self.myMenu?.logOutDelegate = self
        }
    }

}
