//
//  RandomVSViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 7/12/17.
//  Copyright © 2017 Lemon. All rights reserved.
//

import UIKit

class RandomVSViewController: UIViewController {

    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var guestImage: UIImageView!
    @IBOutlet weak var hostUsername: UILabel!
    @IBOutlet weak var guestUsername: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        hostImage.image = hostImage.image?.af_imageRounded(withCornerRadius: 15)
        guestImage.image = guestImage.image?.af_imageRounded(withCornerRadius: 15)
        
        
        
        guestImage.animationImages = [
            UIImage(named: "Image")!,
            UIImage(named: "Image-1")!,
            UIImage(named: "Image-2")!
            
        ]
        
        
        
        guestImage.animationDuration = 0.3
        guestImage.startAnimating()
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.guestImage.stopAnimating()
//            self.guestImage.image = UIImage(named: "Image")!
            
        }
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

}
