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

//////// facebook login
        self.loginFacebookBTN.delegate = self
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
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                self.present(vc, animated: false, completion: nil)

            } else {
                let alertController = UIAlertController(title: "Twitter log in", message:
                    "username or passwor is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
        logInButton.center = self.view.center
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
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
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
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            self.present(vc, animated: false, completion: nil)

    }



}
