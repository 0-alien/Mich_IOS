//
//  EditProfileViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/2/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profilePicture: UIImageView!
    var user: User!
    var image2 : UIImage!

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePicture = self.profilePicture.borderedCircle
        Nuke.loadImage(with: Foundation.URL(string: self.user.avatar!)!, into: self.profilePicture)
        self.userNameTF.text = self.user.name
        self.emailTF.text = self.user.email
        /////
        image2 = profilePicture.image!
        /////
        imagePicker.delegate = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func save(_ sender: Any) {
        let userName = userNameTF.text!;
        let email = emailTF.text!;
        // tokenis ageba
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        image2 = image2.fixedOrientation()
        MichTransport.updateUser(token: appDelegate.token!, name: userName, email: email, avatar: image2, successCallbackForUpdateUser: onupdateuser, errorCallbackForUpdateUser: onUpdateUsererror)
    }
    func onupdateuser(resp: User) {
        (UIApplication.shared.delegate as! AppDelegate).user = resp
        performSegue(withIdentifier: "gotoprofilepage", sender: self)
    }
    
    func onUpdateUsererror(error: DefaultError) {
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //----------- CAMERA -------
    func camera(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func libr(_ sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        image2 = image
        self.profilePicture.image = image.fixedOrientation()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func editProfile(_ sender: Any) {
        let alert = UIAlertController()
        
        let takePicture = UIAlertAction(title: "Take Picture", style: .default, handler: { ACTION in
            self.camera(sender as AnyObject)
        })
        
        let library = UIAlertAction(title: "Choose from library", style: .default, handler: { ACTION in
           
            self.libr(sender as AnyObject)
 
        })
        

        alert.addAction(takePicture)
        alert.addAction(library)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
