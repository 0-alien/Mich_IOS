//
//  CameraLoadViewController.swift
//  Mich
//
//  Created by zuraba on 11/16/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import AVFoundation


class CameraLoadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var myView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createSession()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func photoButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;

            imagePicker.allowsEditing = false;
            
            
            
 //           imagePicker.accessibilityFrame = CGRect(x: 70, y: 70, width: 30, height: 100)
/*
            let controllerView = imagePicker.view
            controllerView?.alpha = 0.5;
            controllerView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIApplication.shared.delegate!.window!?.addSubview(controllerView!)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {() -> Void in
                controllerView?.alpha = 1.0
            }, completion: { _ in })
//////////////////////

            let screenBounds = UIScreen.main.bounds
            let overlayView = UIView(frame: screenBounds)
            
            overlayView.autoresizesSubviews = true
            overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
            let captureButton = UIButton(frame: CGRect(x: CGFloat(screenBounds.size.width / 2 - 30), y: CGFloat(screenBounds.size.height - 60), width: CGFloat(60), height: CGFloat(60)))
           
            captureButton.setBackgroundImage(UIImage(named:"fire_icon")!, for: .normal)
            overlayView.addSubview(captureButton)
            imagePicker.cameraOverlayView = overlayView
            imagePicker.cameraDevice = .rear
*/
 
            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    


    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func libraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
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
