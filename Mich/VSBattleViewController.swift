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
    @IBOutlet weak var firstPointCnt: UILabel!
    @IBOutlet weak var secondPointCnt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        battleTableView.dataSource = self
        battleTableView.delegate = self
        var min = Swift.min(first.frame.size.width, first.frame.size.height)
        first.frame.size = CGSize(width: min, height: min)
        min = Swift.min(second.frame.size.width, second.frame.size.height)
        second.frame.size = CGSize(width: min, height: min)
        first.image = first.image?.circle
        second.image = second.image?.circle
        first.backgroundColor = UIColor.white.withAlphaComponent(0)
        second.backgroundColor = UIColor.white.withAlphaComponent(0)
        navBarExtension.backgroundColor = UIColor.red.withAlphaComponent(0)
        
        battleTableView.rowHeight = UITableViewAutomaticDimension
        battleTableView.estimatedRowHeight = 44.0
        
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
    
    @IBAction func firstTapped(_ sender: Any) {
        firstPointCnt.text = String(Int(firstPointCnt.text!)! + 1)
        showAnimation()
    }
    
    @IBAction func secondTapped(_ sender: Any) {
        secondPointCnt.text = String(Int(secondPointCnt.text!)! + 1)
        showAnimation()
    }
    
    private func showAnimation() {
        let img = UIImageView(image: UIImage(named: "fire_icon"))
        let coef = self.view.frame.size.width / 2.0 / img.frame.size.width
        img.frame = self.view.frame.insetBy(dx: self.view.frame.size.width / 4, dy: self.view.frame.size.height / 2 - img.frame.size.height * coef / 2)
        self.view.addSubview(img)
        UIView.animate(withDuration: 1, animations: {
            img.alpha = 0
        })
    }
    
    //Mark: Battle Table View delegate + data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2 == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BattleTableViewCell") as! BattleTableViewCell
            cell.label.text = "dawdwadawdawdawdn nfn ainfinwaienfiewnaifnew kjgdfn"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BattleTableViewCellB") as! BattleTableViewCellB
            cell.label.text = "dawdwadawdawdawdn nfn ainfinwaienfiewnaifnew kjgdfn fsad jsadfjksadfklsdajfjidsahf idsjfoj nsfdijhf uiahsduifhoisdnf ojasdfoh sdiaugf u8dshofi jsdaojhfi o"
            return cell
        }
    }
}

