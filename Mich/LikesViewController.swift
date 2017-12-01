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
        MichTransport.getLikes(token: (UIApplication.shared.delegate as! AppDelegate).token!, postId: self.postId, successCallbackForGetLikes: onGetLikesSuccess, errorCallbackForGetLikes: onError)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - tableview datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell", for: indexPath) as! LikesTableViewCell
        cell.userPicture = cell.userPicture.circle
        cell.userPicture.af_setImage(withURL: Foundation.URL(string: users[indexPath.row].avatar!)!)
        cell.userName.text = users[indexPath.row].username
        return cell
    }

    // MARK: - callbacks
    func onGetLikesSuccess(resp: [User]) {
        self.users = resp
        self.tableView.reloadData()
    }
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "gotoprofilepage" {
            if let selectedCell = sender as? LikesTableViewCell {
                let indexPath = self.tableView.indexPath(for: selectedCell)
                (segue.destination as! UserPicturesCollectionViewController).userId = self.users[(indexPath?.row)!].id
            } else {
                (segue.destination as! UserPicturesCollectionViewController).userId = (UIApplication.shared.delegate as! AppDelegate).user?.id
            }
        }
    }
}
