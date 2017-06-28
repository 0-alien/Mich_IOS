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
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MichNotificationsTransport.getAllNotifications(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetAllNotifications: onGetAllNotificationsSuccess, errorCallbackForGetAllNotifications: onError)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: tableview data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        cell.data.text = notifications[indexPath.row].message
        cell.userPicture = cell.userPicture.circle
        cell.userPicture.af_setImage(withURL: Foundation.URL(string: notifications[indexPath.row].avatar!)!)
        cell.selectionStyle = .none
        return cell
    }
    // MARK: table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch notifications[indexPath.row].type! {
        case .postLike:
            performSegue(withIdentifier: "showpost", sender: notifications[indexPath.row])
            break
        case .comment:
            performSegue(withIdentifier: "showcomment", sender: notifications[indexPath.row])
            break
        case .commentLike:
            performSegue(withIdentifier: "showcomment", sender: notifications[indexPath.row])
            break
        case .follow:
            performSegue(withIdentifier: "showfollower", sender: notifications[indexPath.row])
            break
        case .battleInvite:
            performSegue(withIdentifier: "showbattle", sender: notifications[indexPath.row])
            break
        case .battleAccept:
            performSegue(withIdentifier: "showbattle", sender: notifications[indexPath.row])
            break
        case .battleFinish:
            performSegue(withIdentifier: "showbattle", sender: notifications[indexPath.row])
            break
        default: break
        }
    }
    
    // MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let notif = sender as? MichNotification else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        if segue.identifier == "showpost" {
            guard let vc = segue.destination as? PostViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.postId = notif.postId!
        }
        else if segue.identifier == "showcomment" {
            guard let vc = segue.destination as? CommentsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.postId = Int(notif.postId!)
            vc.needsToShowComment = true
            vc.destinationCommentId = notif.commentId!
        }
        else if segue.identifier == "showfollower"{
            guard let vc = segue.destination as? FollowViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.ering = true
            vc.needsToShowFollower = true
            vc.destinationFollowerId = notif.followerId
        }
        else if segue.identifier == "showbattle" {
            guard let vc = segue.destination as? VSJSQViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            vc.senderId = String(((UIApplication.shared.delegate as! AppDelegate).user?.id)! + 0)
            vc.senderDisplayName = (UIApplication.shared.delegate as! AppDelegate).user?.username
            vc.battleId = notif.battleId
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
        ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! ScrollingViewController).setNotificationCount(count: 0)
        (UIApplication.shared.delegate as! AppDelegate).unseenNotificationCount = 0
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichNotificationsTransport.getAllNotifications(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackGetAllNotifications: onGetAllNotificationsSuccess, errorCallbackForGetAllNotifications: onError)
    }

}
