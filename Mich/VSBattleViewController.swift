//
//  VSBattleViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 10/13/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit

class VSBattleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var navBarExtension: UIView!
    @IBOutlet weak var first: UIImageView!
    @IBOutlet weak var second: UIImageView!
    @IBOutlet weak var battleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        battleTableView.dataSource = self
        battleTableView.delegate = self
        
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
    
    
    //Mark: Battle Table View delegate + data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BattleTableViewCell") as! BattleTableViewCell
        cell.label.text = String(indexPath.row)
        return cell
    }
}

