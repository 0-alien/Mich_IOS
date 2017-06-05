//
//  HelpViewController.swift
//  Mich
//
//  Created by zuraba on 3/15/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var sendQuestionBTN: UIButton!


//    @IBOutlet weak var ManagingYourAccount: UILabel!
//    @IBOutlet weak var UsingMich: UILabel!
    @IBOutlet weak var ManagingYourAccount: UIButton!
    @IBOutlet weak var UsingMich: UIButton!

    @IBOutlet weak var PrivacySafety: UIButton!
    @IBOutlet weak var TermsAndPolicies: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let usingMich: String = "Using Mich"
        let bulletPoint: String = "\u{2022}"
        let formattedString: String = "\(bulletPoint) \(usingMich)\n"
        UsingMich.setTitle(formattedString,for: .normal)

        let usingMich1: String = "Managing you account"
        let bulletPoint1: String = "\u{2022}"
        let formattedString1: String = "\(bulletPoint1) \(usingMich1)\n"
        ManagingYourAccount.setTitle(formattedString1,for: .normal)

        let usingMich2: String = "Privacy & Safety"
        let bulletPoint2: String = "\u{2022}"
        let formattedString2: String = "\(bulletPoint2) \(usingMich2)\n"
        PrivacySafety.setTitle(formattedString2,for: .normal)

        let TermsAndPoliciesStr: String = "Terms & Policies"
        let bulletPoint3: String = "\u{2022}"
        let formattedString3: String = "\(bulletPoint3) \(TermsAndPoliciesStr)\n"
        TermsAndPolicies.setTitle(formattedString3,for: .normal)
        
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
