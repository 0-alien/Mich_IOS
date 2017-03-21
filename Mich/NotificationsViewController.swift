//
//  NotificationsViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 3/13/17.
//  Copyright © 2017 Gigi. All rights reserved.
//

import UIKit

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
        MichTransport.getAllNotifications(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForHidePost: onGetAllNotificationsSuccess, errorCallbackForHidePost: onError)
        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "VSInviteCell", for: indexPath) as! VSInviteCell
        cell.data.text = notifications[indexPath.row].message
        return cell
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
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        MichTransport.getAllNotifications(token: (UIApplication.shared.delegate as! AppDelegate).token!, successCallbackForHidePost: onGetAllNotificationsSuccess, errorCallbackForHidePost: onError)
    }

}
