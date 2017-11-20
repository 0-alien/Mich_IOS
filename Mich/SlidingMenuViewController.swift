//
//  SlidingMenuViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/6/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import Nuke
import UIKit

class SlidingMenuViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var notifications: UIView!
    @IBOutlet weak var messenger: UIView!
    @IBOutlet weak var settings: UIView!
    @IBOutlet weak var help: UIView!
    @IBOutlet weak var notificationCountView: UIView!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    var logOutDelegate: LogoutDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture = profilePicture.borderedCircle
        Nuke.loadImage(with: Foundation.URL(string: ((UIApplication.shared.delegate as! AppDelegate).user?.avatar)!)!, into: profilePicture)
        userName.text = (UIApplication.shared.delegate as! AppDelegate).user?.username
            
        notifications.layer.shadowOpacity = 0.3
        notifications.layer.shadowRadius = 1.0
        notifications.layer.shadowColor = UIColor.black.cgColor;
        notifications.layer.shadowOffset = CGSize(width: 0, height: 3)
        notifications.layer.masksToBounds = false
        
        messenger.layer.shadowOpacity = 0.3
        messenger.layer.shadowRadius = 1.0
        messenger.layer.shadowColor = UIColor.black.cgColor;
        messenger.layer.shadowOffset = CGSize(width: 0, height: 3)
        messenger.layer.masksToBounds = false
        
        settings.layer.shadowOpacity = 0.3;
        settings.layer.shadowRadius = 1.0;
        settings.layer.shadowColor = UIColor.black.cgColor;
        settings.layer.shadowOffset = CGSize(width: 0, height: 3)
        settings.layer.masksToBounds = false
        
        notificationCountView.layer.cornerRadius = notificationCountView.frame.size.height / 2.0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logOut(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        MichTransport.logout(token: appDelegate.token!, successCallbackForLogout: onLogout, errorCallbackForLogout: onError)
    }
    
    func onLogout(){
        logOutDelegate.logOut();
    }
    
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - manage notification count
    
    func setNotificationCount(count: Int) {
        if count == 0 {
            self.notificationCountView.isHidden = true
            self.notificationCountLabel.text = "0"
        }
        else if count < 0 {
            return
        }
        else {
            self.notificationCountView.isHidden = false
            self.notificationCountLabel.text = String(count)
        }
    }
    
    func incrementNotificationCount(by: Int) {
        var curCount = Int(self.notificationCountLabel.text!)
        curCount = curCount! + by
        if curCount! < 0 {
            return
        }
        else if curCount == 0 {
            self.notificationCountView.isHidden = true
        }
        else if curCount! == by {
            self.notificationCountView.isHidden = false
        }
        self.notificationCountLabel.text = String(curCount!)
    }
    
    // MARK: - Actions
    
    @IBAction func showNotifications(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showNotifications"), object: nil)
    }
    @IBAction func showMessages(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showMessages"), object: nil)
    }
    @IBAction func showSettings(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showSettings"), object: nil)
    }
    @IBAction func showHelp(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showHelp"), object: nil)
    }
}

protocol LogoutDelegate {
    func logOut();
}
