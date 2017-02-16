//
//  EditImageViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/16/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var photo: UIImageView!
    var img: UIImage!
    @IBOutlet weak var titleTF: UITextField!
    var postTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = img
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.postTitle = textField.text
        textField.resignFirstResponder()
    }
}
