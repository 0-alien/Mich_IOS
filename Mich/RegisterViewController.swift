//
//  RegisterViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signUpNameTF: UITextField!
    @IBOutlet weak var signUpLastname: UITextField!

    @IBOutlet weak var signUpUsername: UITextField!
    
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpConfirmPassword: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpNameTF.layer.shadowOpacity = 0.3;
        signUpNameTF.layer.shadowRadius = 1.0;
        signUpNameTF.layer.shadowColor = UIColor.black.cgColor;
        signUpNameTF.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpNameTF.layer.masksToBounds = false
        

        signUpLastname.layer.shadowOpacity = 0.3;
        signUpLastname.layer.shadowRadius = 1.0;
        signUpLastname.layer.shadowColor = UIColor.black.cgColor;
        signUpLastname.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpLastname.layer.masksToBounds = false


        signUpUsername.layer.shadowOpacity = 0.3;
        signUpUsername.layer.shadowRadius = 1.0;
        signUpUsername.layer.shadowColor = UIColor.black.cgColor;
        signUpUsername.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpUsername.layer.masksToBounds = false


        signUpEmail.layer.shadowOpacity = 0.3;
        signUpEmail.layer.shadowRadius = 1.0;
        signUpEmail.layer.shadowColor = UIColor.black.cgColor;
        signUpEmail.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpEmail.layer.masksToBounds = false
        

        signUpPassword.layer.shadowOpacity = 0.3;
        signUpPassword.layer.shadowRadius = 1.0;
        signUpPassword.layer.shadowColor = UIColor.black.cgColor;
        signUpPassword.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpPassword.layer.masksToBounds = false
        

        signUpConfirmPassword.layer.shadowOpacity = 0.3;
        signUpConfirmPassword.layer.shadowRadius = 1.0;
        signUpConfirmPassword.layer.shadowColor = UIColor.black.cgColor;
        signUpConfirmPassword.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpConfirmPassword.layer.masksToBounds = false
        
        signUpButton.layer.shadowOpacity = 0.3;
        signUpButton.layer.shadowRadius = 1.0;
        signUpButton.layer.shadowColor = UIColor.black.cgColor;
        signUpButton.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpButton.layer.masksToBounds = false
      
        
        signUpNameTF.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1.0)
        signUpNameTF.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpLastname.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpLastname.attributedPlaceholder = NSAttributedString(string:"Lastname", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpUsername.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpUsername.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpEmail.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpEmail.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpPassword.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpPassword.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpConfirmPassword.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpConfirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpButton.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        
        
   
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButton(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        self.present(vc, animated: false, completion: nil)

    
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == signUpConfirmPassword || textField == signUpPassword){
            scrollView.setContentOffset(CGPoint(x:0, y:250), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       if(textField == signUpConfirmPassword || textField == signUpPassword){
            scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
