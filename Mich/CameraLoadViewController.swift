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
    
    
}
