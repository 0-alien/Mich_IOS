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
    @IBOutlet weak var ressetPassworBTN: UIButton!
    @IBOutlet weak var changePassBTN: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!

   
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
    
    
}
