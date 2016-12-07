//
//  SlidingMenuViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/6/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class SlidingMenuViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.image = profilePicture.image?.circle
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

    @IBAction func logOut(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Cabinet", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: false, completion: nil)
    }
}