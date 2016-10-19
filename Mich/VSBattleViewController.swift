//
//  VSBattleViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/13/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSBattleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = VSBattleNavBarView(frame: CGRect(x: 0, y: 0,
                width: self.navigationController!.navigationBar.frame.size.width,
                height: self.navigationController!.navigationBar.frame.size.height),
                                                           firstImage: (UIImage(named: "register_background")?.circle)!, firstScore: 10,
                                                           secondImage: (UIImage(named: "login_background")?.circle)!, secondScore: 15)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clicked(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
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
