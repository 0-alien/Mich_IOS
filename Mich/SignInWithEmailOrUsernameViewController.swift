//
//  SignInWithEmailOrUsernameViewController.swift
//  Mich
//
//  Created by zuraba on 10/31/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class SignInWithEmailOrUsernameViewController: UIViewController {

    
    @IBOutlet weak var SignInBTN: UIButton!
    @IBOutlet weak var userNameOrEmailTX: UITextField!
    @IBOutlet weak var signInTX: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameOrEmailTX.layer.shadowOpacity = 0.3;
        userNameOrEmailTX.layer.shadowRadius = 1.0;
        userNameOrEmailTX.layer.shadowColor = UIColor.black.cgColor;
        userNameOrEmailTX.layer.shadowOffset = CGSize(width: -4, height: 4)
        userNameOrEmailTX.layer.masksToBounds = false
        
        
        signInTX.layer.shadowOpacity = 0.3;
        signInTX.layer.shadowRadius = 1.0;
        signInTX.layer.shadowColor = UIColor.black.cgColor;
        signInTX.layer.shadowOffset = CGSize(width: -4, height: 4)
        signInTX.layer.masksToBounds = false


        SignInBTN.layer.shadowOpacity = 0.3;
        SignInBTN.layer.shadowRadius = 1.0;
        SignInBTN.layer.shadowColor = UIColor.black.cgColor;
        SignInBTN.layer.shadowOffset = CGSize(width: -4, height: 4)
        SignInBTN.layer.masksToBounds = false

        
        userNameOrEmailTX.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        userNameOrEmailTX.attributedPlaceholder = NSAttributedString(string:"Username or Email", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signInTX.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signInTX.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        SignInBTN.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func SignInButton(_ sender: AnyObject) {
        if(userNameOrEmailTX.text == "" || signInTX.text == ""){
            let alertController = UIAlertController(title: "Log In", message:
                "username or passwor is incorrect", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        self.present(vc, animated: false, completion: nil)
    
    
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
