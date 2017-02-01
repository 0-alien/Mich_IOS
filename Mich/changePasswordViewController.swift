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

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
