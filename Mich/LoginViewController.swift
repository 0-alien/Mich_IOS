//
//  LoginViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var smallSignUpView: UIView!
    
    @IBOutlet var FullView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setToolbarHidden(_ hidden: Bool,
                          animated: Bool){
        
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        scrollView.setContentOffset(CGPoint(x:0, y:250), animated: true)
       

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }


    
    


    
    
    
    @IBAction func login(_ sender: AnyObject) {
        
        if (loginTF.text == "gigi" || passwordTF.text == "12345" || true) {
            let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            self.present(vc, animated: false, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
