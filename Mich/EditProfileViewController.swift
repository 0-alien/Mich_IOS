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
    var userId: Int!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.image = profilePicture.image?.circle
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prep")
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
