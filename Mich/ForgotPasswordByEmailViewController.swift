//
//  ForgotPasswordByEmailViewController.swift
//  Mich
//
//  Created by zuraba on 11/2/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class ForgotPasswordByEmailViewController: UIViewController {

    @IBOutlet weak var forgotPasswordNextButton: UIButton!
    @IBOutlet weak var forgotPasswordEmailTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotPasswordEmailTF.layer.shadowOpacity = 0.3;
        forgotPasswordEmailTF.layer.shadowRadius = 1.0;
        forgotPasswordEmailTF.layer.shadowColor = UIColor.black.cgColor;
        forgotPasswordEmailTF.layer.shadowOffset = CGSize(width: -4, height: 4)
        forgotPasswordEmailTF.layer.masksToBounds = false

        
        forgotPasswordEmailTF.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        forgotPasswordEmailTF.attributedPlaceholder = NSAttributedString(string:"Username or Email", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])


        forgotPasswordNextButton.layer.shadowOpacity = 0.3;
        forgotPasswordNextButton.layer.shadowRadius = 1.0;
        forgotPasswordNextButton.layer.shadowColor = UIColor.black.cgColor;
        forgotPasswordNextButton.layer.shadowOffset = CGSize(width: -4, height: 4)
        forgotPasswordNextButton.layer.masksToBounds = false


        forgotPasswordNextButton.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func forgotPasswordNextButton(_ sender: AnyObject) {
    }

}
