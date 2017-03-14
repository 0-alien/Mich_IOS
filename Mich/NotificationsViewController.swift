//
//  NotificationsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/13/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1 ..< 10 {
            data.append(String(i))
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tableview data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VSInviteCell", for: indexPath) as! VSInviteCell
        cell.data.text = data[indexPath.row]
        return cell
    }
}
