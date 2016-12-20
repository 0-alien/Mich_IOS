//
//  SlidingMenuPresentingViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/19/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class SlidingMenuPresentingViewController: UIViewController {
    
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showNotifications), name: NSNotification.Name(rawValue: "showNotifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showMessages), name: NSNotification.Name(rawValue: "showMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showSettings), name: NSNotification.Name(rawValue: "showSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showHelp), name: NSNotification.Name(rawValue: "showHelp"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func showNotifications() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "notifications", sender: nil)
        }
    }
    func showMessages() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "messages", sender: nil)
        }
    }
    func showSettings() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "settings", sender: nil)
        }
    }
    func showHelp() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "help", sender: nil)
        }
    }
}
