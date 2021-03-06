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
import GoogleSignIn
import Firebase


class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    @IBOutlet weak var smallSignUpView: UIView!
    
    @IBOutlet var FullView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    
    
    @IBOutlet weak var loginFacebookBTN: FBSDKLoginButton!
    
//////// pod instalacia: rvm use system, sudo gem install cocoapods, pod install
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.usernameTXT.delegate = self
        self.passwordTXT.delegate = self
        
        
        usernameTXT.layer.shadowOpacity = 0.3;
        usernameTXT.layer.shadowRadius = 1.0;
        usernameTXT.layer.shadowColor = UIColor.black.cgColor;
        usernameTXT.layer.shadowOffset = CGSize(width: -4, height: 4)
        usernameTXT.layer.masksToBounds = false
        
        
        passwordTXT.layer.shadowOpacity = 0.3;
        passwordTXT.layer.shadowRadius = 1.0;
        passwordTXT.layer.shadowColor = UIColor.black.cgColor;
        passwordTXT.layer.shadowOffset = CGSize(width: -4, height: 4)
        passwordTXT.layer.masksToBounds = false

        
        
        usernameTXT.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:0.9)
        usernameTXT.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        
        passwordTXT.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:0.9)
        passwordTXT.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 1)])
        
        

        
        // google login
/*
        
        let googleSignButton  = GIDSignInButton();
        view.addSubview(googleSignButton);
        
        self.view.addSubview(googleSignButton)
        let consG1 = NSLayoutConstraint(item: googleSignButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let consG2 = NSLayoutConstraint(item: googleSignButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let consG3 = NSLayoutConstraint(item: googleSignButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN , attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 95)
        
        googleSignButton.addConstraint(NSLayoutConstraint(item: googleSignButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))
        
        
        
        googleSignButton.translatesAutoresizingMaskIntoConstraints = false;
        
        self.view.addConstraints([consG1, consG2, consG3]);
        
*/
        
        self.loginFacebookBTN.isHidden = true;
        
        //////// facebook login
        self.loginFacebookBTN.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        loginFacebookBTN.readPermissions = ["public_profile", "email", "user_friends"]
        
        
        let token = FBSDKAccessToken.current()
        if(FBSDKAccessToken.current() == nil){
            print("logaedout")
            print(String(describing: token))
        }else{
            print(String(describing: token))
            print("loggedIn")
            
        }

        ////////////////////////

        //////// twitter

        
/*
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ScrollingViewController") as! UIViewController
                self.present(vc, animated: false, completion: nil)

            } else {
                let alertController = UIAlertController(title: "Twitter log in", message:
                    "username or passwor is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        })

        
        self.view.addSubview(logInButton)
        let cons1 = NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let cons2 = NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let cons3 = NSLayoutConstraint(item: logInButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: loginFacebookBTN , attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 40)
        
       logInButton.addConstraint(NSLayoutConstraint(item: logInButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30))

        

        logInButton.translatesAutoresizingMaskIntoConstraints = false;

        self.view.addConstraints([cons1, cons2, cons3]);
*/
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton, didCompleteWith result: FBSDKLoginManagerLoginResult, error: Error?) {
        
        if(error != nil){
            print(error?.localizedDescription as Any)
            return
        }
        if let userToken = result.token {
            let token:FBSDKAccessToken = result.token
            print(userToken)
            print(token)
            let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ScrollingViewController")
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
            self.dismiss(animated: true, completion: nil)
            //self.present(vc, animated: false, completion: nil)

        }

        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton) {
   
    }
    
    
    
    func setToolbarHidden(_ hidden: Bool,
                          animated: Bool){
        
    }
    
    //////////////////////////////////////////////////////// requestis gagzavna ///////////////////////////////////////////
    
    @IBAction func login(_ sender: AnyObject) {
        
        let user = usernameTXT.text!
        let pass = passwordTXT.text!
        MichTransport.defaultLogin(username: user, password: pass, successCallback: onLogin, errorCallback: onError)
    }
    
    
    func onLogin(token: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.token = token
        if let contents = FIRInstanceID.instanceID().token() {
            print("jer firebase moxda")
            MichTransport.updateFirebaseToken(token: (appDelegate.token)!, firToken: contents, successCallbackForGetBattles: {}, errorCallbackForGetBattles: onError)
        }
        MichTransport.getcurrentuser(token: (appDelegate.token)!, successCallbackForgetcurrentuser: ongetcurrentuser, errorCallbackForgetcurrentuser: onError)
    }
    
    
    func ongetcurrentuser(getcurrentuserResponse: User){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user = getcurrentuserResponse
        let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScrollingViewController")
        
        let defaults = UserDefaults.standard
        defaults.set(String(getcurrentuserResponse.id!), forKey: "userid")
        defaults.set(String(appDelegate.token!), forKey: "token")
        
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = vc
        self.dismiss(animated: false, completion: nil)
    }
    
    func onError(error: DefaultError){
        
         let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
        
    }
    ////////////////////////////////////////////////////////                      ///////////////////////////////////////////

    ///////////////////// keyboard code
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        login(self)
        
        return true
    }
    

    /////////////////////
    

}
