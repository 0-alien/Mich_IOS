//
//  NavigationViewController.swift
//  Mich
//
//  Created by zuraba on 9/22/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController {
    @IBOutlet weak var container: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Userspace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        vc.view.frame = container.frame
        container.addSubview(vc.view)
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
