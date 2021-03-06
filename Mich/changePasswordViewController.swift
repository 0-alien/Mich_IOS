//
//  changePasswordViewController.swift
//  Mich
//
//  Created by zuraba on 1/30/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class changePasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var resetBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        codeTF.layer.shadowOpacity = 0.3;
        codeTF.layer.shadowRadius = 1.0;
        codeTF.layer.shadowColor = UIColor.black.cgColor;
        codeTF.layer.shadowOffset = CGSize(width: -4, height: 4)
        codeTF.layer.masksToBounds = false
        
        
        codeTF.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        codeTF.attributedPlaceholder = NSAttributedString(string:"code", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])

        
        newPasswordTF.layer.shadowOpacity = 0.3;
        newPasswordTF.layer.shadowRadius = 1.0;
        newPasswordTF.layer.shadowColor = UIColor.black.cgColor;
        newPasswordTF.layer.shadowOffset = CGSize(width: -4, height: 4)
        newPasswordTF.layer.masksToBounds = false
        
        
        newPasswordTF.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        newPasswordTF.attributedPlaceholder = NSAttributedString(string:"New password", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])

        
        confirmPasswordTF.layer.shadowOpacity = 0.3;
        confirmPasswordTF.layer.shadowRadius = 1.0;
        confirmPasswordTF.layer.shadowColor = UIColor.black.cgColor;
        confirmPasswordTF.layer.shadowOffset = CGSize(width: -4, height: 4)
        confirmPasswordTF.layer.masksToBounds = false
        
        
        confirmPasswordTF.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        confirmPasswordTF.attributedPlaceholder = NSAttributedString(string:"confirm password", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        resetBTN.layer.shadowOpacity = 0.3;
        resetBTN.layer.shadowRadius = 1.0;
        resetBTN.layer.shadowColor = UIColor.black.cgColor;
        resetBTN.layer.shadowOffset = CGSize(width: -4, height: 4)
        resetBTN.layer.masksToBounds = false

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetButton(_ sender: Any) {
        let redColor  = #colorLiteral(red: 0.7740760446, green: 0.1117314473, blue: 0.09814801067, alpha: 1)
        let code = codeTF.text!;
        let password = newPasswordTF.text!
        let confirmPassword = confirmPasswordTF.text!
        if(password != confirmPassword){
            confirmPasswordTF.text = "";
            newPasswordTF.text = "";
            newPasswordTF.layer.borderColor = redColor.cgColor;
            newPasswordTF.layer.borderWidth = 2.0;
            confirmPasswordTF.layer.borderColor = redColor.cgColor;
            confirmPasswordTF.layer.borderWidth = 2.0;
            return;
        }

        ////// tokenis ageba
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        MichTransport.checkcode(token: appDelegate.token!, code: code, successCallbackForCheckCode: onCheckCode, errorCallbackForCheckCode: onError)

    }
    
    func onCheckCode(){
//      performSegue(withIdentifier: "onsuccess", sender: self)
        let password = newPasswordTF.text!;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        MichTransport.recover(token: appDelegate.token!, password: password, successCallbackForRecover: onRecover, errorCallbackForRecover: onError)
    }
    
    
    func onRecover(){
        let storyboard = UIStoryboard(name: "Cabinet", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
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
        resetButton(self)
        return true
    }
    /////////////////////
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
