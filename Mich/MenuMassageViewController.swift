//
//  MenuMassageViewController.swift
//  Mich
//
//  Created by zuraba on 7/11/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class MenuMassageViewController: UIViewController {
    @IBOutlet weak var testImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        testImage.animationImages = [
            UIImage(named: "Image")!,
            UIImage(named: "Image-1")!,
            UIImage(named: "Image-2")!
            
        ]
        testImage.animationDuration = 0.5
        testImage.startAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func change(_ sender: Any) {
        testImage.stopAnimating()
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
