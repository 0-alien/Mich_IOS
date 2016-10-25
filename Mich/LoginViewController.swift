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
/*
        loginTF.delegate = self
        passwordTF.delegate = self
        loginTF.backgroundColor = UIColor (red:236 / 255.0, green:68 / 255.0, blue:45 / 255.0, alpha:0.5)
        passwordTF.backgroundColor = UIColor (red:236 / 255.0, green:68 / 255.0, blue:45 / 255.0, alpha:0.5)
        loginTF.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        passwordTF.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if(UIDevice.current.userInterfaceIdiom == .pad ){
            
            print("Ipod")
        }else{
            print("another device")
        }
*/
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



    
    

/*
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        scrollView.setContentOffset(CGPoint(x:0, y:250), animated: true)
       

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }

     
     func dismissKeyboard() {
     //Causes the view (or one of its embedded text fields) to resign the first responder status.
     view.endEditing(true)
     }
     
     
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     return true
     }
     
     
*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
