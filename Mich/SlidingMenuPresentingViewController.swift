//
//  SlidingMenuPresentingViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 12/19/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class SlidingMenuPresentingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var currentIndex = 0
    var vv: Camera!
    var isCameraShown: Bool = false
    var cameraPhoto: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isCameraShown = false
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showNotifications), name: NSNotification.Name(rawValue: "showNotifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showMessages), name: NSNotification.Name(rawValue: "showMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showSettings), name: NSNotification.Name(rawValue: "showSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.showHelp), name: NSNotification.Name(rawValue: "showHelp"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.cameraClicked), name: NSNotification.Name(rawValue: "showChoose"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SlidingMenuPresentingViewController.hideChoose), name: NSNotification.Name(rawValue: "hideChoose"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func cameraClicked() {
        if (tabBarController?.selectedIndex == currentIndex) {
            if (self.isCameraShown) {
                hideChoose()
            }
            else {
                self.isCameraShown = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: "disableScrolling"), object: nil)
                vv = Camera(frame: self.view.bounds)
                vv.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                vv.gallery.addTarget(self, action: #selector(self.libr(_:)), for: .touchUpInside)
                vv.camera.addTarget(self, action: #selector(self.camera(_:)), for: .touchUpInside)
                self.view.addSubview(vv)
            }
        }
    }
    
    func hideChoose() {
        if (tabBarController?.selectedIndex == currentIndex) {
            if (self.isCameraShown) {
                self.isCameraShown = false
                NotificationCenter.default.post(name: Notification.Name(rawValue: "enableScrolling"), object: nil)
                vv.removeFromSuperview()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if (isCameraShown) {
            hideChoose()
        }
    }
    
    //----------- CAMERA -------
    func camera(_ sender: AnyObject) {
        vv.removeFromSuperview()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func libr(_ sender: AnyObject) {
        vv.removeFromSuperview()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        self.cameraPhoto = image
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "gotoeditimage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "gotoeditimage") {
            (segue.destination as! EditImageViewController).img = self.cameraPhoto
        }
    }
    
    @IBAction func unwindFromCamera(sender: UIStoryboardSegue) {
        let img = (sender.source as! EditImageViewController).img
        var title = (sender.source as! EditImageViewController).postTitle
        if (title == nil) {
            title = ""
        }
        MichTransport.createpost(token: (UIApplication.shared.delegate as! AppDelegate).token!, title: title!, image: img!,
                                 successCallbackForCreatePost: self.oncreatesuccess, errorCallbackForCreatePost: self.oncreateerror)
        
    }
    
    //Mark: oncreate callbacks
    
    func oncreatesuccess() {
        self.tabBarController?.selectedIndex = 0
        print("daido")
    }
    
    func oncreateerror(error: DefaultError) {
        print("ver daido")
    }
    //------------------
    
    func showNotifications() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "notifications", sender: nil)
        }
    }
    func showMessages() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "messages", sender: nil)
        }
    }
    func showSettings() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "settings", sender: nil)
        }
    }
    func showHelp() {
        if (tabBarController?.selectedIndex == currentIndex) {
            performSegue(withIdentifier: "help", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "disableScrolling"), object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "enableScrolling"), object: nil)
    }
}
