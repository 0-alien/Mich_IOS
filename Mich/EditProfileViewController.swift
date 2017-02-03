//
//  EditProfileViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/2/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prep")
    }
    @IBAction func cancel(_ sender: Any) {
        print("DAWDAW")
        self.dismiss(animated: true, completion: nil)
    }
}
