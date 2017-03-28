//
//  NotificationsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/13/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit
import AlamofireImage

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var notifications: [MichNotification] = []
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NotificationsViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        MichNotificationsTransport.getAllNotifications(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetAllNotifications: onGetAllNotificationsSuccess, errorCallbackForGetAllNotifications: onError)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: tableview delegate

    // MARK: tableview data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = nil
        var c: Any?
        switch notifications[indexPath.row].type! {
        case 1:
            let c = tableView.dequeueReusableCell(withIdentifier: "PostLikedCell", for: indexPath) as! PostLikedCell
            c.data.text = notifications[indexPath.row].message
            c.avatar = c.avatar.circle
            c.avatar.af_setImage(withURL: Foundation.URL(string: notifications[indexPath.row].avatar!)!)
            cell = c
            break
        case 2:
            let c = tableView.dequeueReusableCell(withIdentifier: "CommentAddedCell", for: indexPath) as! CommentAddedCell
            c.data.text = notifications[indexPath.row].message
            c.avatar = c.avatar.circle
            c.avatar.af_setImage(withURL: Foundation.URL(string: notifications[indexPath.row].avatar!)!)
            cell = c
            break
        case 3:
            let c = tableView.dequeueReusableCell(withIdentifier: "CommentLikedCell", for: indexPath) as! CommentLikedCell
            c.data.text = notifications[indexPath.row].message
            c.avatar = c.avatar.circle
            c.avatar.af_setImage(withURL: Foundation.URL(string: notifications[indexPath.row].avatar!)!)
            cell = c
            break
        case 4:
            let c = tableView.dequeueReusableCell(withIdentifier: "FollowCell", for: indexPath) as! FollowCell
            c.data.text = notifications[indexPath.row].message
            c.avatar = c.avatar.circle
            c.avatar.af_setImage(withURL: Foundation.URL(string: notifications[indexPath.row].avatar!)!)
            cell = c
            break
        case 5:
            let c = tableView.dequeueReusableCell(withIdentifier: "VSInviteCell", for: indexPath) as! VSInviteCell
            c.data.text = notifications[indexPath.row].message
            c.avatar = c.avatar.circle
            c.avatar.af_setImage(withURL: Foundation.URL(string: notifications[indexPath.row].avatar!)!)
            cell = c
            break
        case 6:
            let c = tableView.dequeueReusableCell(withIdentifier: "VSAcceptCell", for: indexPath) as! VSAcceptCell
            c.data.text = notifications[indexPath.row].message
            c.avatar = c.avatar.circle
            c.avatar.af_setImage(withURL: Foundation.URL(string: notifications[indexPath.row].avatar!)!)
            cell = c
            break
        default: break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postliked" {
            guard let vc = segue.destination as? PostViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let cell = sender as? PostLikedCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            let indexPath = self.tableView.indexPath(for: cell)
            vc.postId = notifications[(indexPath?.row)!].itemId
        }
        else if segue.identifier == "commentadded" {
            guard let vc = segue.destination as? CommentsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let cell = sender as? CommentAddedCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            let indexPath = self.tableView.indexPath(for: cell)
            vc.postId = notifications[(indexPath?.row)!].itemId
        }
        else if segue.identifier == "commentliked" {
            guard let vc = segue.destination as? CommentsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let cell = sender as? CommentLikedCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            let indexPath = self.tableView.indexPath(for: cell)
            vc.postId = notifications[(indexPath?.row)!].itemId
        }
        
    }
    
    // MARK: callbacks
    func onError(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func onGetAllNotificationsSuccess(resp: [MichNotification]) {
        self.notifications.removeAll()
        self.notifications.append(contentsOf: resp)
        self.tableView.reloadData()
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        MichNotificationsTransport.markNotificationsSeen(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForMarkNotifications: onSeenAllNotificationsSuccess, errorCallbackForMarkNotifications: onError)
    }
    
    func onSeenAllNotificationsSuccess() {
        ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! ScrollingViewController).myMenu?.setNotificationCount(count: 0)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichNotificationsTransport.getAllNotifications(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetAllNotifications: onGetAllNotificationsSuccess, errorCallbackForGetAllNotifications: onError)
    }

}
