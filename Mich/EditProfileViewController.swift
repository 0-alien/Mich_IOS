//
//  EditProfileViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/2/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.image = profilePicture.image?.circle
        
        
        imagePicker.delegate = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let userName = userNameTF.text!;
        let email = emailTF.text!;
        
        // tokenis ageba
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        MichTransport.updateUser(token: appDelegate.token!, name: userName, email: email, avatar: profilePicture.image!, successCallbackForUpdateUser: onupdateuser, errorCallbackForUpdateUser: onUpdateUsererror)
        
        
        
        
    }
    
    func onupdateuser(resp: User) {
        print("+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_ success")
    }
    
    func onUpdateUsererror(error: DefaultError) {
        print("+_+_+_+_+_++_+_+_+_+_+_+_+_+_+_+_ error")
        
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        print("DAWDAW")
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
        self.profilePicture.image = image.circle
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func editProfile(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Profile", message: "", preferredStyle: .alert)
        
        let takePicture = UIAlertAction(title: "Take Picture", style: .default, handler: { ACTION in
            self.camera(sender as AnyObject)
        })
        
        let library = UIAlertAction(title: "Choose from library", style: .default, handler: { ACTION in
           
            self.libr(sender as AnyObject)
            
            
        })
        
       
        
        alert.addAction(takePicture)
        alert.addAction(library)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }

}
