//
//  LoginViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TwitterKit



class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    @IBOutlet weak var smallSignUpView: UIView!
    
    @IBOutlet var FullView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var loginFacebookBTN: FBSDKLoginButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

//////// pod instalacia: rvm use system, sudo gem install cocoapods, pod install
//////// facebook login
        self.loginFacebookBTN.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        loginFacebookBTN.readPermissions = ["public_profile", "email", "user_friends"]
        
        let toekn = FBSDKAccessToken.current()
        if(FBSDKAccessToken.current() == nil){
            print("logaedout")
            print(toekn)
            
        }else{
            print(toekn)
            print("loggedIn")
            
        }
////////////////////////
//////// twitter
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UIViewController
                self.present(vc, animated: false, completion: nil)

            } else {
                let alertController = UIAlertController(title: "Twitter log in", message:
                    "username or passwor is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
        logInButton.center = self.view.center

/*
        let cons1 = NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let cons2 = NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let cons3 = NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 3.2, constant: 0)
        logInButton.translatesAutoresizingMaskIntoConstraints = false;

        self.view.addConstraints([cons1, cons2, cons3]);
*/
        self.view.addSubview(logInButton)
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton, didCompleteWith result: FBSDKLoginManagerLoginResult, error: Error?) {
        
        if(error != nil){
            print(error?.localizedDescription)
            return
        }
        if let userToken = result.token {
            let token:FBSDKAccessToken = result.token
            print(userToken)
            print(token)
            let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UIViewController
            self.present(vc, animated: false, completion: nil)

        }

        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            print("aaaaaaaaaajajajajajajjajajajajajajajajaja")
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
    }
    
    
    
    func setToolbarHidden(_ hidden: Bool,
                          animated: Bool){
        
    }
    
    
    
    @IBAction func login(_ sender: AnyObject) {
        
            let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UIViewController
            self.present(vc, animated: false, completion: nil)

    }



}
