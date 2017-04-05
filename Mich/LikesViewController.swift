//
//  LikesViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 4/5/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import AlamofireImage

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var postId: Int!
    var users: [User]! = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell", for: indexPath) as! LikesTableViewCell
        cell.userPicture.af_setImage(withURL: Foundation.URL(string: users[indexPath.row].avatar!)!)
        cell.userName.text = users[indexPath.row].username
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
