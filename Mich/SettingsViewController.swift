//
//  SettingsViewController.swift
//  Mich
//
//  Created by zuraba on 12/23/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

//    @IBOutlet weak var passwordView: UIView!
//    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    @IBOutlet weak var heightCons: NSLayoutConstraint!

    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPassworTF: UITextField!
    @IBOutlet weak var confirmPassworTF: UITextField!
    
    @IBOutlet weak var ressetPassworBTN: UIButton!
    @IBOutlet weak var changePassBTN: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!

    @IBOutlet weak var switchBT: UISwitch!
    
    @IBOutlet weak var saveBTN: UIButton!
    
    @IBOutlet weak var emailHeightCons: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        view1.layer.shadowOpacity = 0.3;
        view1.layer.shadowRadius = 1.0;
        view1.layer.shadowColor = UIColor.black.cgColor;
        view1.layer.shadowOffset = CGSize(width: 0, height: 3)
        view1.layer.masksToBounds = false

        view2.layer.shadowOpacity = 0.3;
        view2.layer.shadowRadius = 1.0;
        view2.layer.shadowColor = UIColor.black.cgColor;
        view2.layer.shadowOffset = CGSize(width: 0, height: 3)
        view2.layer.masksToBounds = false

        view3.layer.shadowOpacity = 0.3;
        view3.layer.shadowRadius = 1.0;
        view3.layer.shadowColor = UIColor.black.cgColor;
        view3.layer.shadowOffset = CGSize(width: 0, height: 3)
        view3.layer.masksToBounds = false

        view4.layer.shadowOpacity = 0.3;
        view4.layer.shadowRadius = 1.0;
        view4.layer.shadowColor = UIColor.black.cgColor;
        view4.layer.shadowOffset = CGSize(width: 0, height: 3)
        view4.layer.masksToBounds = false

        view5.layer.shadowOpacity = 0.3;
        view5.layer.shadowRadius = 1.0;
        view5.layer.shadowColor = UIColor.black.cgColor;
        view5.layer.shadowOffset = CGSize(width: 0, height: 3)
        view5.layer.masksToBounds = false

        view6.layer.shadowOpacity = 0.3;
        view6.layer.shadowRadius = 1.0;
        view6.layer.shadowColor = UIColor.black.cgColor;
        view6.layer.shadowOffset = CGSize(width: 0, height: 3)
        view6.layer.masksToBounds = false
  
        view7.layer.shadowOpacity = 0.3;
        view7.layer.shadowRadius = 1.0;
        view7.layer.shadowColor = UIColor.black.cgColor;
        view7.layer.shadowOffset = CGSize(width: 0, height: 3)
        view7.layer.masksToBounds = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switchBT.isOn = ((UIApplication.shared.delegate as! AppDelegate).user?.isPrivate)!
    }
    
    @IBAction func passwordBTN(_ sender: Any) {
        self.view.layoutIfNeeded()
        
        if(heightCons.constant == 0){
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.heightCons.constant = 200;
                self.view.layoutIfNeeded()
            })
            ressetPassworBTN.isHidden = false;

        }else{
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.heightCons.constant = 0;
                self.view.layoutIfNeeded()
            })
            ressetPassworBTN.isHidden = true;
        }
    }
    
    @IBAction func resetPasswordBTN(_ sender: Any) {
        let redColor  = #colorLiteral(red: 0.7740760446, green: 0.1117314473, blue: 0.09814801067, alpha: 1)
        let oldPassword = oldPasswordTF.text!
        let password = newPassworTF.text!
        let confirmPassword = confirmPassworTF.text!
        if(password != confirmPassword){
            confirmPassworTF.text = "";
            newPassworTF.text = "";
            newPassworTF.layer.borderColor = redColor.cgColor;
            newPassworTF.layer.borderWidth = 2.0;
            confirmPassworTF.layer.borderColor = redColor.cgColor;
            confirmPassworTF.layer.borderWidth = 2.0;
            return;
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        MichTransport.changepassword(token: appDelegate.token!, password: password, oldPassword:oldPassword, successCallbackForChangePassword: onChnagePassword, errorCallbackForChnagePassword: onError)
    }

    func onChnagePassword(){
        let alert = UIAlertController(title: "Alert", message: "Password Changed!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func changeEmailBTN(_ sender: Any) {
        self.view.layoutIfNeeded() // force any pending operations to finish
        if(emailHeightCons.constant == 0){
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.emailHeightCons.constant = 130;
                self.view.layoutIfNeeded()
            })
            saveBTN.isHidden = false;
        }else{
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.emailHeightCons.constant = 0;
                self.view.layoutIfNeeded()
            })
            saveBTN.isHidden = true;
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
    
    @IBAction func switchBTN(_ sender: Any) {
        if(!switchBT.isOn){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            MichTransport.togglePrivacyStatus(token: appDelegate.token!, successCallbackForTogglePrivacyStatus: offTogglePrivacyStatus, errorCallbackForTogglePrivacyStatus: onError)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            MichTransport.togglePrivacyStatus(token: appDelegate.token!, successCallbackForTogglePrivacyStatus: onTogglePrivacyStatus, errorCallbackForTogglePrivacyStatus: onError)
        }
    }
    
    func onTogglePrivacyStatus(){
        let alert = UIAlertController(title: "Alert", message: "Your account is now private", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        (UIApplication.shared.delegate as! AppDelegate).user?.isPrivate = true
    }
    
    func offTogglePrivacyStatus(){
        let alert = UIAlertController(title: "Alert", message: "Your account is now public", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        (UIApplication.shared.delegate as! AppDelegate).user?.isPrivate = false
    }
}
