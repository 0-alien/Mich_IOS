//
//  VSBattleViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/13/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSBattleViewController: UIViewController {

    
    @IBOutlet weak var navBarExtension: UIView!
    @IBOutlet weak var first: UIImageView!
    @IBOutlet weak var second: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.image = first.image?.circle
        second.image = second.image?.circle
        first.backgroundColor = UIColor(red: 255.0 / 255, green: 29.0 / 255 , blue: 45.0 / 255, alpha: 1)
        second.backgroundColor = UIColor(red: 255.0 / 255, green: 29.0 / 255 , blue: 45.0 / 255, alpha: 1)
        navBarExtension.backgroundColor = UIColor(red: 255.0 / 255, green: 29.0 / 255 , blue: 45.0 / 255, alpha: 1)
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
