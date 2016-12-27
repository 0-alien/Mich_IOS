//
//  ForgorPasswordViewController.swift
//  Mich
//
//  Created by zuraba on 11/2/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class ForgorPasswordViewController: UIViewController {

    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view2.layer.shadowOpacity = 0.3;
        view2.layer.shadowRadius = 1.0;
        view2.layer.shadowColor = UIColor.black.cgColor;
        view2.layer.shadowOffset = CGSize(width: 0, height: 3)
        view2.layer.masksToBounds = false
        
        view2.backgroundColor = UIColor (red:193 / 255.0, green:54 / 255.0, blue:24 / 255.0, alpha:1)
 
        view3.layer.shadowOpacity = 0.3;
        view3.layer.shadowRadius = 1.0;
        view3.layer.shadowColor = UIColor.black.cgColor;
        view3.layer.shadowOffset = CGSize(width: 0, height: 3)
        view3.layer.masksToBounds = false
        
        view3.backgroundColor = UIColor (red:193 / 255.0, green:54 / 255.0, blue:24 / 255.0, alpha:1)

        
        view4.layer.shadowOpacity = 0.3;
        view4.layer.shadowRadius = 1.0;
        view4.layer.shadowColor = UIColor.black.cgColor;
        view4.layer.shadowOffset = CGSize(width: 0, height: 3)
        view4.layer.masksToBounds = false
        
        view4.backgroundColor = UIColor (red:193 / 255.0, green:54 / 255.0, blue:24 / 255.0, alpha:1)
        

        
        view5.layer.shadowOpacity = 0.3;
        view5.layer.shadowRadius = 1.0;
        view5.layer.shadowColor = UIColor.black.cgColor;
        view5.layer.shadowOffset = CGSize(width: 0, height: 3)
        view5.layer.masksToBounds = false
        
        view5.backgroundColor = UIColor (red:193 / 255.0, green:54 / 255.0, blue:24 / 255.0, alpha:1)

        view6.layer.shadowOpacity = 0.3;
        view6.layer.shadowRadius = 1.0;
        view6.layer.shadowColor = UIColor.black.cgColor;
        view6.layer.shadowOffset = CGSize(width: 0, height: 3)
        view6.layer.masksToBounds = false
        
        view6.backgroundColor = UIColor (red:193 / 255.0, green:54 / 255.0, blue:24 / 255.0, alpha:1)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true

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
