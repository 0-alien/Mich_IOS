//
//  FollowViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 2/23/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import Nuke

class FollowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var ering: Bool! // followeing or follower
    var users: [User] = [User]()
    var user: User!
    
    var needsToShowFollower: Bool? = false
    var destinationFollowerId: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ering! {
            self.navigationItem.title = "Followers"
            MichTransport.getUserFollowers(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: ((UIApplication.shared.delegate as! AppDelegate).user?.id!)!,
                                           successCallbackForGetFollowers: onSuccess, errorCallbackForGetFollowers: onError);
        }
        else {
            self.navigationItem.title = "Following"
            MichTransport.getUserFollowing(token: (UIApplication.shared.delegate as! AppDelegate).token!, id: ((UIApplication.shared.delegate as! AppDelegate).user?.id!)!,
                                           successCallbackForGetFollowing: onSuccess, errorCallbackForGetFollowing: onError)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: tableview datasource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FollowTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FollowTableViewCell
        cell.userName.text = users[indexPath.row].username
        cell.userPicture = cell.userPicture.circle
        Nuke.loadImage(with: Foundation.URL(string: users[indexPath.row].avatar!)!, into: cell.userPicture)
        return cell
    }
    
    //Mark: callbacks
    func onSuccess(data: [User]) {
        self.users.removeAll()
        self.users.append(contentsOf: data)
        self.tableView.reloadData()
        if needsToShowFollower! {
            needsToShowFollower = false
            for i in 0 ..< data.count {
                if data[i].id == self.destinationFollowerId {
                    tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: false)
                    let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! FollowTableViewCell
                    cell.backgroundColor = UIColor.orange
                    UIView.animate(withDuration: 1, animations: {cell.backgroundColor = UIColor.white})
                    break
                }
            }
        }
    }
    
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "gotoprofilepage" {
            if let selectedCell = sender as? FollowTableViewCell {
                let indexPath = tableView.indexPath(for: selectedCell)
                (segue.destination as! UserPicturesCollectionViewController).userId = users[(indexPath?.row)!].id
            }
        }
    }
    
}
